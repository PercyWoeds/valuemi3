class Document < ActiveRecord::Base

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


end
