class Employee < ActiveRecord::Base

	before_save :set_full_name
	
	has_many :outputs
	
  validates_uniqueness_of :IdNumber
  validates_presence_of :company_id, :IdNumber, :firstname,:lastname
 

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		

	end 
	
	def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Employee.create! row.to_hash 
        end
    end       
    

end
