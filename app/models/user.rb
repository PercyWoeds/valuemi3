class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  :rememberable, :trackable, :validatable
  
  
   self.per_page = 20
  
  attr_accessible :id, :username, :email, :password, :salt, :encrypted_password, :first_name, :last_name, :level 

 # validates_presence_of :username, :email, :password, :level, :first_name, :last_name
  validates_uniqueness_of  :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  has_many :sessions
  has_many :users_packages
  has_many :companies
  has_many :company_users
  has_many :invoices
  has_many :inventories

  
  def print
    return '<a href="/users/' + self.id.to_s + '">' + self.username + '</a>'
  end
  
  def get_name
    if(self.first_name and self.last_name)
      return "#{self.first_name} #{self.last_name}"
    end
  end
  
  def get_companies
    #companies = Company.where(user_id: self.id).order("name")
    #alr_ids = []
    
   # for company in companies
   #   alr_ids.push(company.id)
   # end
   # 
    # Check if we gotta add shared companies
    company_users = CompanyUser.where(user_id: self.id)
    
    for cu in company_users
    
        curr_company = Company.find(cu.company_id)
        companies.push(curr_company)
    
    end
    
    return companies
  end
  
  def get_locations
    companies = self.get_companies
    locations = []
    
    for company in companies
      c_locations = Location.where(company_id: company.id)
      
      locations.push(c_locations)
    end
    
    return locations
  end
  
  def get_users
    companies = self.get_companies
    users = []
    alr_ids = []
    
    for company in companies
      ccus = CompanyUser.where(company_id: company.id)
      
      for company_user in ccus
        user = company_user.user
        
        if(not alr_ids.include?(user.id))
          users.push(user)
          alr_ids.push(user.id)
        end
      end
    end
    
    return users
  end
  
  def companies_left
    companies = self.get_companies
    package = self.package
    
    if(package.companies == 0)
      return -1000 # unlimited
    else
      left = package.companies - companies.count
      
      if(left <= 0)
        return 0
      else
        return left
      end
    end
  end
  
  def print_companies_left
    companies_left = self.companies_left
    
    if(companies_left > 0)
      return companies_left
    elsif(companies_left == -1000)
      # Unlimited
      return "Unlimited"
    elsif(companies_left <= 0)
      return 0
    end
  end
  
  def companies_left_class
    companies_left = self.companies_left
    
    if(companies_left > 0 or companies_left == -1000)
      return "notice"
    else
      return "error"
    end
  end
  
  def locations_left
    locations = self.get_locations
    package = self.package
    
    if(package.locations == 0)
      return -1000 # unlimited
    else
      left = package.locations - locations.count
      
      if(left <= 0)
        return 0
      else
        return left
      end
    end
  end
  
  def print_locations_left
    locations_left = self.locations_left
    
    if(locations_left > 0)
      return locations_left
    elsif(locations_left == -1000)
      # Unlimited
      return "Unlimited"
    elsif(locations_left <= 0)
      return 0
    end
  end
  
  def locations_left_class
    locations_left = self.locations_left
    
    if(locations_left > 0 or locations_left == -1000)
      return "notice"
    else
      return "error"
    end
  end
  
  def users_left
    users = self.get_users
    package = self.package
    
    if(package.users == 0)
      return -1000 # unlimited
    else
      left = package.users - users.count
      
      if(left <= 0)
        return 0
      else
        return left
      end
    end
  end
  
  def print_users_left
    users_left = self.users_left
    
    if(users_left > 0)
      return users_left
    elsif(users_left == -1000)
      # Unlimited
      return "Unlimited"
    elsif(users_left <= 0)
      return 0
    end
  end
  
  def users_left_class
    users_left = self.users_left
    
    if(users_left > 0 or users_left == -1000)
      return "notice"
    else
      return "error"
    end
  end
  
  def package
    user_package = UsersPackage.where(user_id: self.id)
    
    if user_package
      return user_package[0].package
    end
  end
  
  class << self
    
  def self.serialize_from_session(key, salt)
  record = to_adapter.get(key[0].as_json["$oid"])
  record if record && record.authenticatable_salt == salt
  end
  
end

  
end
  

