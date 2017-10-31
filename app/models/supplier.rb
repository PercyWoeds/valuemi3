class Supplier < ActiveRecord::Base
  validates_presence_of :company_id, :name
  validates_uniqueness_of :ruc
  
  belongs_to :company
  
  has_many :products
  has_many :restocks

  
  has_many :purchases
  has_many :purchaseorders
  has_many :supplier_payments
  has_many :outputs
  
  
  def get_taxable
    if(self.taxable == "1")
      return "Taxable"
    else
      return "Not taxable"
    end
  end

    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Supplier.create! row.to_hash 
        end
      end  

end

