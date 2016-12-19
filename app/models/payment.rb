class Payment < ActiveRecord::Base
 validates_presence_of :company_id, :descrip
  
  belongs_to :company
  
  has_many :facturas 
  has_many :serviceorders 
end
