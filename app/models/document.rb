class Document < ActiveRecord::Base

  before_save :set_fullname
  before_update :set_fullname
  
  
  has_many :movement_details
	has_many :locations
  has_many :suppliers
  has_many :products
  has_many :products_kits
  has_many :restocks
  has_many :divisions
  has_many :purchases
  has_many :purchaseorders
  has_many :serviceorders
  has_many :customers
  has_many :invoices
  has_many :inventories
  has_many :company_users  
  has_many :customer_payments
  has_many :viaticos 
  has_many :viatico_details
  has_many :tmp_facturas
  
  def set_fullname
    self.fullname ="#{self.descripshort} #{self.description}".strip		
    
  end
  
end
