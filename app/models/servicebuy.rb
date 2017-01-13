class Servicebuy < ActiveRecord::Base

	validates_presence_of :name, :cost, :price, :company_id
  validates_numericality_of :cost, :price, :tax1, :tax2, :tax3
  
  belongs_to :company
  belongs_to :supplier
  
  has_many :restocks

  has_many :serviceorder_services

  has_many :purchase_details
  

  def get_name(id)

  	servicio = Servicebuy.find(id)	

  	return servicio 

  end 
  
end
