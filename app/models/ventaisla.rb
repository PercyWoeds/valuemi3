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
def  get_ventas_combustibles_producto(fecha1,producto,value) 
    
    lcFecha1= fecha1.strftime('%Y-%m-%d')   
    ret=0  
    puts lcFecha1 
    
     facturas = VentaislaDetail.where(["fecha >= ?  and fecha <= ? and ventaisla_details.product_id = ?","#{lcFecha1} 00:00:00","#{lcFecha1} 23:59:59",producto])
    
    if facturas
    ret=0  
    for factura in facturas
      if value == "qty"
        ret+= factura.quantity
      else
        ret += factura.total 
    
      end
    end
    
    end 

    return ret
  
    
    return facturas
    
 end 
       
    

end
