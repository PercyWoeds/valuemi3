class Customer < ActiveRecord::Base
  validates_presence_of :company_id, :name
  
  belongs_to :company
  
  has_many :invoices
  has_many :manifests
  
  has_many :addresses , :dependent => :destroy
  
  accepts_nested_attributes_for :addresses, :reject_if => lambda { |a| a[:address].blank? }, :allow_destroy => true


  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Customer.create! row.to_hash 
        end
      end       
      

  
  def get_taxable
    if(self.taxable == "1")
      return "Taxable"
    else
      return "Not taxable"
    end
  end
end
