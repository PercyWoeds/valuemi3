class ViaticoDetail < ActiveRecord::Base
    
     validates_presence_of :viatico_id, :tranportorder_id,  :importe,:supplier_id , :gasto_id
  
    belongs_to :viatico  
    belongs_to :tranportorder
    
end
