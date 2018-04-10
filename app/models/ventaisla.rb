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
    
     facturas = Ventaisla.where(["fecha >= ? and fecha <= ?  " , "#{lcFecha1} 00:00:00 ","#{lcFecha1} 23:59:59" ])
     
     if facturas
         
        
        
        for detalle in facturas
        
              factura_detalle = VentaislaDetail.where(["ventaisla_id = ? and product_id = ?" , detalle.id,producto ])
                for detalle in factura_detalle
                    if value =="gln"
                      ret += detalle.quantity.round(2)*-1
                    else
                      ret += detalle.total.round(2)*-1
                    end 
                end     
            
        end 
    end 

    return ret
 
 end 
       
    

end
