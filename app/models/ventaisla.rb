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
def  get_ventas_combustibles_producto(fecha1,producto) 
    
    lcFecha1= fecha1.strftime('%Y-%m-%d')   
    ret=0  
    
     facturas = Ventaisla.find_by_sql(['Select ventaisla.fecha,sum(quantity) as quantity,sum(total) as importe 
     from Ventaisla
     INNER JOIN ventaisla_details on ventaisla.id= ventaisla_details.ventaisla_id 
     WHERE ventaisla.fecha >= ? and ventaisla.fecha <= ? and ventaisla_details.product_id = ?
     GROUP BY ventaisla.fecha,ventaisla_details.product_id',"#{lcFecha1} 00:00:00","#{lcFecha1} 00:00:00",producto])

    return ret
 
 end 
       
    

end
