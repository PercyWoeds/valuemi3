class Supplier < ActiveRecord::Base
  validates_presence_of :company_id, :name
  
  belongs_to :company
  
  has_many :products
  has_many :restocks

  
  has_many :purchases
  has_many :purchaseorders
  
  def get_taxable
    if(self.taxable == "1")
      return "Taxable"
    else
      return "Not taxable"
    end
  end
end

