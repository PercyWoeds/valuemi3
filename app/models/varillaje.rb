class Varillaje < ActiveRecord::Base
    
    belongs_to :tanque
    
 def  get_compras(fecha,producto) 

     facturas = Purchase.where(["date2 >= ? and date2 <= ?  and tiponota <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","3" ])
     
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
     
 def  get_ventas_importe(fecha,producto) 

     facturas = Ventaisla.where(["fecha >= ? and fecha <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
        
              factura_detalle = VentaislaDetail.where(["ventaisla_id = ? and product_id = ?" , detalle.id,producto ])
                for detalle in factura_detalle
                
                    ret += detalle.total.round(2)*-1
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
 
 def  get_ventas_contometros_producto(fecha,producto) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N",producto])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_producto_todo(fecha,producto) 
     #no incluye ventas directas

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_prod = ? and tipo <> ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",producto,"3"])
     
     if facturas
         
        ret  = 0  
        ret2 = 0
        for detalle in facturas
            ret  += detalle.importe.to_f
        end 
               
     end 
     return ret 
 
 end 
 
  
 def  get_ventas_contometros_descuento_producto(fecha,producto) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3",producto ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
        
             
                 
                if detalle.implista > 0
                    ret += detalle.implista - detalle.importe.to_f
                else
                    ret += 0
                end
            
        end 
     end 

    return ret
 
 end 
 
 
 def  get_ventas_contometros_efectivo(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ?  and tipo<> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N","2"])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_efectivo_sustento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N"]).order(:serie,:numero)
     
     
    return facturas
 
 end 
 def  get_ventas_contometros_tarjeta_sustento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago <> ? and td <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N"]).order(:serie,:numero)
     
     
    return facturas
 
 end 
 
 
 
 def  get_ventas_contometros_tarjeta(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago <> ?  and td <> ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N","1"])
     
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
            ret += detalle.implista
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_adelantado(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","4" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
             ret += detalle.implista
       end 
    end 

    return ret
 
 end 
 
 
 def  get_ventas_creditos_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ]).order(:serie,:numero)

    return facturas
 
 end 
 
  def  get_ventas_contado_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2" ]).order(:serie,:numero)

    return facturas
 
 end 
 
  def  get_ventas_directa_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ]).order(:serie,:numero)

    return facturas
 
 end 
 
 def  get_ventas_contometros_descuento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            if detalle.implista > 0
            ret += detalle.implista - detalle.importe.to_f
         
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
 #Datos solo de cabecera de cobranzas
 def get_customer_payments_1(fecha1)
     @facturas =  CustomerPayment.where(['fecha1>= ? and fecha1 <= ? and document_id = 14', "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
     return @facturas 
     
     
     
 end  
 def get_customer_payments_2(fecha1)
     @facturas =  CustomerPayment.where(['fecha1>= ? and fecha1 <= ? and document_id <> 14', "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
     return @facturas 
 end  
     
 def  get_ventas_vale_contado(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
             ret += detalle.importe.to_f
        
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_vale_directo_producto(fecha,producto,value) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  and cod_prod  = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3",producto ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            if value == "qty"
                ret += detalle.cantidad.to_f
            else   
                ret += detalle.importe.to_f
            end 
             
        end 
    end 

    return ret
 
 end 
 
 
 def  get_ventas_vale_directo(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
             ret += detalle.importe.to_f
        end 
    end 

    return ret
 
 end 
 
 
 def get_afericion_total_dia(fecha)
     facturas = Afericion.where(["fecha >= ? and fecha <= ?   " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
       ret=0  
       
     if facturas
         
       for detalle in facturas
          ret += detalle.importe
       end 
       
     end 
     return ret 
 end 
 def get_afericion_total_dia_producto(fecha,producto)
     
     facturas = Afericion.where(["fecha >= ? and fecha <= ?  and tanque_id = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
       ret=0  
       
     if facturas
         
       for detalle in facturas
          ret += detalle.importe
       end 
       
     end 
     return ret 
 end 
 
 def get_faltante_total_dia(fecha,tipo)
     facturas = Faltante.where(["fecha >= ? and fecha <= ?  and tipofaltante_id = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",tipo ])
       ret=0  
       
     if facturas
         
       for detalle in facturas
        if tipo == "1"           
             ret -= detalle.total 
         else
             ret += detalle.total 
         end 
       end 
       
     end 
     return ret
 end 
 
 def get_faltante_detalle_dia(fecha,tipo)
     facturas = Faltante.where(["fecha >= ? and fecha <= ?  and tipofaltante_id = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",tipo ])
       ret=0  
     
     return facturas 
 end 
 
 
 def get_ventas_market(fecha)
     
     facturas = Factura.where(["fecha >= ? and fecha <= ?   " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
       ret=0  
       
     if facturas
         
       for factura in facturas
          
          detalles = FacturaDetail.where(factura_id: factura.id)     
             
          for   detalle    in detalles
            
             if (detalle.product.products_category.id != 1  )
                 if (detalle.product.products_category.id != 3  )
                 
                ret += detalle.total 
                end 
             end 
             
          end 
          
       end 
       
     end 
     
     return ret 
 end 
 
 def get_ventas_restaurant(fecha)
     
     facturas = Factura.where(["fecha >= ? and fecha <= ?   " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
       ret=0  
       
     if facturas
         
       for factura in facturas
          
          detalles =     FacturaDetail.where(factura_id: factura.id)     
             
          for   detalle    in detalles
            
             if detalle.product.products_category_id == 3 
                    ret += detalle.total 
             end 
          end 
          
       end 
       
     end 
     
     return ret 
 end 
 
 
end
