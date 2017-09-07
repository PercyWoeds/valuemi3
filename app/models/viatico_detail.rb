class ViaticoDetail < ActiveRecord::Base
    
     validates_presence_of :viatico_id, :tranportorder_id,  :importe , :gasto_id,:employee_id ,:fecha 
  
    belongs_to :viatico  
    belongs_to :tranportorder
    belongs_to :supplier 
    belongs_to :gasto 
    belongs_to :employee
    
end
