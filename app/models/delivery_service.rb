class DeliveryService < ActiveRecord::Base

  validates_presence_of :delivery_id, :service_id, :price, :quantity, :discount, :total
  
  belongs_to :delivery 
  belongs_to :service 

end
