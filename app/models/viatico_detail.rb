class ViaticoDetail < ActiveRecord::Base
    
    validates_presence_of :viatico_id, :tranportorder_id,  :importe , :gasto_id,:employee_id,:document_id
  
    belongs_to :viatico  
    belongs_to :tranportorder
    belongs_to :supplier 
    belongs_to :gasto 
    belongs_to :employee
    belongs_to :document 
    
    
    def get_detalle
        ret =""
        if self.tranportorder.code !="9999" 
            ret = self.tranportorder.code << " - " << self.tranportorder.truck.placa<<" - " << self.tranportorder.get_placa(self.tranportorder.truck2_id)
        end 
        return ret 
    end 
end
