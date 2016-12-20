class ServiceorderService < ActiveRecord::Base

validates_presence_of :serviceorder_id, :servicebuy_id, :price, :quantity, :total
  
  belongs_to :serviceorder	
  belongs_to :servicebuy
   

end
