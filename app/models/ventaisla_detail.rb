class VentaislaDetail < ActiveRecord::Base
     belongs_to :ventaisla 
     belongs_to :pump
     belongs_to :product 
     
       validates_presence_of :pump_id, :product_id
       
      
end
