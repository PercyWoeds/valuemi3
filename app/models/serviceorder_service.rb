class ServiceorderService < ActiveRecord::Base

validates_presence_of :serviceorder_id, :service_id, :price_with_tax, :quantity, :total
  
  belongs_to :serviceorder	
  belongs_to :servicebuy
   

end
