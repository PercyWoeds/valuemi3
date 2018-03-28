class Varillaje < ActiveRecord::Base
    
    belongs_to :tanque
    
 def  get_compras(fecha,producto) 

     facturas = Purchase.where(["date1 >= ? and date1 <= ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
    ret=0  
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ?" , factura.id,producto ])
                for detalle in factura_detalle
                    ret += detalle.quantity.round(2)
                end     
        end
    end 

    return ret
 
 end 
 def  get_ventas(fecha,producto) 

     facturas = Ventaisla.where(["fecha >= ? and fecha <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
        
              factura_detalle = VentaislaDetail.where(["ventaisla_id = ? and product_id = ?" , detalle.id,producto ])
                for detalle in factura_detalle
                    ret += detalle.quantity.round(2)
                end     
            
        end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros(fecha) 

     facturas = Ventaisla.where(["fecha >= ? and fecha <= ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f*-1
       end 
    end 

    return ret
 
 end 
 def  get_ventas_contometros_efectivo(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N"])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 def  get_ventas_contometros_tarjeta(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago <> ?  and td <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N"])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 def  get_ventas_contometros_creditos(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 

end
