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
                    ret += detalle.quantity.round(2)*-1
                end     
            
        end 
    end 

    return ret
 
 end 
 
    
 def  get_ventas_directo(fecha,producto) 

     facturas = Factura.where(["fecha >= ? and fecha <= ? and tipoventa = 2" , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
    ret=0  
        for factura in facturas
                factura_detalle = FacturaDetail.where(["factura_id = ? and product_id = ?" , factura.id,producto ])
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

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_descuento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            if detalle.implista > 0
            ret += detalle.implista - detalle.importe.to_f
          else
             ret += detalle.importe.to_f
          end
       end 
    end 

    return ret
 
 end 
 
 
 def get_customer_payments(fecha1,fecha2)
    @facturas =   CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
facturas.moneda_id,customer_payments.bank_acount_id,
customer_payment_details.factory,
customer_payments.fecha1
from customer_payment_details   
INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id  
WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? order by customer_payments.code', "#{fecha1} 00:00:00",
"#{fecha2} 23:59:59" ])  
    
    return @facturas   
    
 end
 
 def  get_ventas_vale_contado(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
          if detalle.implista >0
            ret += detalle.implista - detalle.importe.to_f
          else
             ret += detalle.importe.to_f
          end 
       end 
    end 

    return ret
 
 end 
 

end
