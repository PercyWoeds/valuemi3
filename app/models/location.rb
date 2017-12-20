class Location < ActiveRecord::Base
  validates_presence_of :company_id, :name
  
  belongs_to :company
  
  has_many :divisions
  has_many :invoices
  has_many :purchases
  has_many :employees
  
end
