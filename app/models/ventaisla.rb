class Ventaisla < ActiveRecord::Base
      
    validates_presence_of :employee_id
    
    
    belongs_to :employee 
    
    has_many :ventaisla_details, :dependent => :destroy
    
    
    
    belongs_to :payroll 
    
    def get_importe_1(value="total")
        
        facturas = VentaislaDetail.where(["ventaisla_id = ? ", self.id ])
        ret=0  
        
        for factura in facturas
            if(value == "total")
              ret += factura.total
            end 
            if(value == "galones")
              ret += factura.quantity
            end
            
        end    

        return ret
        
    end 
def  get_ventas_combustibles_producto(isla,producto,value) 
    
    ret=0  
    
    
     facturas = VentaislaDetail.where(["ventaisla_id = ? and product_id = ?",isla,producto])
    
    if facturas
    ret=0  
    for factura in facturas
      if value == "qty"
        ret+= factura.quantity * -1
      else
        ret += factura.total * -1 
    
      end
    end
    
    end 

    return ret
  
    
    return facturas
    
 end 
       
    

end
