class Marca < ActiveRecord::Base

	validates_presence_of :company_id, :descrip

  belongs_to :company
  
  has_many :trucks
  has_many :products
  

end
