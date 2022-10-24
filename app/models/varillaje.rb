class Varillaje < ActiveRecord::Base
    
    
    belongs_to :tanque

    TABLE_HEADERS  = ["FECHA CORTE ",
                      "HORA CORTE",
                     "EXISTENCIAS DEL 
                     PRODUCTO,SEGUN
                     INVENTARIO
                     FISICO ANTERIOR",

                     "TOTAL DE 
                     INGRESOS DEL 
                     PRODUCTO
                      COMPRAS",
                     "DEVOLUCIONES
                     DEL PRODUCTO 
                     A TANQUES",
                     "TOTAL DE
                     SALIDAS DEL
                     PRODUCTO
                     (VENTAS)",
                     "ET=NUEVA
                     EXISTENCIA
                     TEORICA",
                     "EF=NUEVA EXISTENCIA
                     FISICA SEGUN 
                     VARILLAJE ",
                     "Di=DIFERENCIA
                     ENTRE EXISTENCIA
                     FISICA Y TEORICA",
                     "REGISTRAR CUALQUIER
                     SUCESO RELEVANTE
                     DURANTE PERIODO
                     REGISTRADO",
                    "OBSERVACIONES",
                    " FIRMA "]
                    

    
 def  get_compras(fecha,producto) 

     facturas = Purchase.where(["date2 >= ? and date2 <= ?  and tiponota <> ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","3" ])
     
     if facturas
    ret=0  
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ?" , factura.id,producto ])
                for detalle in factura_detalle

                    if !detalle.grifo.nil?

                     ret += detalle.grifo.round(2)

                    else
                        ret += 0 
                    end 

                end     
        end
    end 

    return ret
 
 end 

   
 def  get_compras20(fecha,producto) 

    
   ret = 0

    factura_detalle = PurchaseDetail.where(["fecha1 >= ? and fecha1 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty1.nil?

         ret += detalle.qty1.round(2)

        else
            ret += 0 
        end 

    end     


    factura_detalle = PurchaseDetail.where(["fecha2 >= ? and fecha2 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty2.nil?

         ret += detalle.qty2.round(2)

        else
            ret += 0 
        end 

    end     

    factura_detalle = PurchaseDetail.where(["fecha3 >= ? and fecha3 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty3.nil?

         ret += detalle.qty3.round(2)

        else
            ret += 0 
        end 

    end     


 factura_detalle = PurchaseDetail.where(["fecha4 >= ? and fecha4 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty4.nil?

         ret += detalle.qty4.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha5 >= ? and fecha5 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty5.nil?

         ret += detalle.qty5.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha6 >= ? and fecha6 <= ?  and
   product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty6.nil?

         ret += detalle.qty6.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha7 >= ? and fecha7 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty7.nil?

         ret += detalle.qty7.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha8 >= ? and fecha8 <= ?  and
       product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty8.nil?

         ret += detalle.qty8.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha9 >= ? and fecha9 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty9.nil?

         ret += detalle.qty9.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha10 >= ? and fecha10 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty10.nil?

         ret += detalle.qty10.round(2)

        else
            ret += 0 
        end 

    end     



    return ret
 
 end 


  
 def  get_compras21(fecha,producto) 

    
   ret = 0

    factura_detalle = PurchaseDetail.where(["fecha1 >= ? and fecha1 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty1.nil?

         ret += detalle.qty1.round(2)

        else
            ret += 0 
        end 

    end     


    factura_detalle = PurchaseDetail.where(["fecha2 >= ? and fecha2 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty2.nil?

         ret += detalle.qty2.round(2)

        else
            ret += 0 
        end 

    end     

    factura_detalle = PurchaseDetail.where(["fecha3 >= ? and fecha3 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty3.nil?

         ret += detalle.qty3.round(2)

        else
            ret += 0 
        end 

    end     


 factura_detalle = PurchaseDetail.where(["fecha4 >= ? and fecha4 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty4.nil?

         ret += detalle.qty4.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha5 >= ? and fecha5 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty5.nil?

         ret += detalle.qty5.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha6 >= ? and fecha6 <= ?  and
   product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty6.nil?

         ret += detalle.qty6.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha7 >= ? and fecha7 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty7.nil?

         ret += detalle.qty7.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha8 >= ? and fecha8 <= ?  and
       product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty8.nil?

         ret += detalle.qty8.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha9 >= ? and fecha9 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty9.nil?

         ret += detalle.qty9.round(2)

        else
            ret += 0 
        end 

    end     



 factura_detalle = PurchaseDetail.where(["fecha10 >= ? and fecha10 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    for detalle in factura_detalle

        if !detalle.qty10.nil?

         ret += detalle.qty10.round(2)

        else
            ret += 0 
        end 

    end     



    return ret
 
 end 

def  get_ticket_glp(fecha) 

     facturas = Ticket.where(["fecha >= ? and fecha <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
     if facturas
    ret=0  
        for detalle  in facturas
                
                    
           ret += detalle.cantidad.round(2)
                  
    
        end
    end 

    return ret
 
 end 

 

def  get_ticket_glp_det(fecha) 

     facturas = Ticket.where(["fecha >= ? and fecha <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
    

    return facturas 
 
 end 



 def  get_compras20_det(fecha,producto) 

    
   ret = 0

    factura_detalle1 = PurchaseDetail.where(["fecha1 >= ? and fecha1 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    
  
    

    factura_detalle2 = PurchaseDetail.where(["fecha2 >= ? and fecha2 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    
       


    factura_detalle3 = PurchaseDetail.where(["fecha3 >= ? and fecha3 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
   
 


 factura_detalle4 = PurchaseDetail.where(["fecha4 >= ? and fecha4 <= ?  and
     product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    



 factura_detalle5 = PurchaseDetail.where(["fecha5 >= ? and fecha5 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
    

 factura_detalle6 = PurchaseDetail.where(["fecha6 >= ? and fecha6 <= ?  and
   product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
  
  

 factura_detalle7  = PurchaseDetail.where(["fecha7 >= ? and fecha7 <= ?  and
      product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
 


 factura_detalle8 = PurchaseDetail.where(["fecha8 >= ? and fecha8 <= ?  and
       product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
   

 factura_detalle9 = PurchaseDetail.where(["fecha9 >= ? and fecha9 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
   
     
 factura_detalle10  = PurchaseDetail.where(["fecha10 >= ? and fecha10 <= ?  and
        product_id = ?","#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
  
    factura_detalle  = factura_detalle1 + factura_detalle2    



    return ret
 
 end 

 

 
 def  get_compras2(fecha1,fecha2,producto) 

     facturas = Purchase.where(["date2 >= ? and date2 <= ?  and tiponota <> ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","3" ])
     
     if facturas
    ret=0  
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ?" , factura.id,producto ])
                for detalle in factura_detalle

                      if !detalle.grifo.nil?

                     ret += detalle.grifo.round(2)

                    else
                        ret += 0 
                    end 



                end     
        end
    end 

    return ret
 
 end 
 
 
 
 def  get_compras3(fecha1,fecha2,producto) 

     facturas = Purchase.where(["date2 >= ? and date2 <= ? and document_id = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","8"])
     
     if facturas
     ret=0  
    
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ? " , factura.id,producto ])
                for detalle in factura_detalle
                    if detalle.document_id == 2
                        ret -= detalle.mayorista.round(2)
                    else
                        ret += detalle.mayorista.round(2)
                    end
                
                end     
        end
     
    end 
 
    return ret
 
 end 
 
 def  get_compras4(fecha1,fecha2,producto) 

     facturas = Purchase.where(["date2 >= ? and date2 <= ?  and document_id <> ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","8"])
     ret=0  
     
     if facturas
     
     
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ? " , factura.id,producto ])
                for detalle in factura_detalle
                    ret += detalle.mayorista.round(2)
                end     
        end
     
    end 
 
    return ret
 
 end 
 
 
 #-------------------------------------------------------------------------------------------------------------------------
 
  def  get_ventas_nota_credito(fecha1,fecha2,producto) 

     facturas = Factura.where(["fecha >= ? and fecha <= ?  and document_id = ? and tipoventa_id = ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","2","2"])
     ret=0  
     
     if facturas
     
        for factura in facturas
                factura_detalle = FacturaDetail.where(["factura_id = ? and product_id = ? " , factura.id,producto ])
                for detalle in factura_detalle
                    ret += detalle.quantity.round(2)
                end     
        end
    end 
 
    return ret
 
 end 
 
 
def  get_inicial(fecha1,producto,producto2) 

    
     compras = 0   
     ventas = 0
     salidas = 0
     saldo = 0
     
     facturas = Purchase.where(["date2 < ?  " , "#{fecha1} 00:00:00"]) 
     if facturas
    
        for factura in facturas
                factura_detalle = PurchaseDetail.where(["purchase_id = ? and product_id = ?" , factura.id,producto ])
                for detalle in factura_detalle
                    compras += detalle.mayorista.round(2)
                end     
        end
    end 

     facturas = Sellvale.where(["fecha < ? and td = ? and tipo  = ?  and cod_prod  = ? " , "#{fecha1} 00:00:00", "N","3",producto2 ])
     
     if facturas

        for detalle in facturas
        
                ventas += detalle.cantidad
        end 
    end 
    
    facturas = Output.where(["fecha < ?  " , "#{fecha1} 00:00:00"]) 
     if facturas
    
        for factura in facturas
                factura_detalle = OutputDetail.where(["output_id = ? and product_id = ?" , factura.id,producto ])
                for detalle in factura_detalle
                    salidas += detalle.quantity.round(2)
                end     
        end
    end 

    

    saldo =  compras - salidas- ventas  
    return saldo 
    
    
    
    
    
 
 end 
 
 def  get_devol(fecha,producto) 

    
      ret = 0
      factura_detalle = Devol.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","#{producto}" ])
        
        for detalle in factura_detalle
            ret += detalle.qty.round(2)
        end     
 

       return ret
 
 end 


  def  get_ventas(fecha,producto) 
     

         ret=0  
         
      facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","#{producto}" ])
     
      if facturas
      
         for detalle in facturas
    
              ret += detalle.cantidad.round(6)
      
         end 
     end 




     @ventas  = Factura.where('fecha>= ? and fecha <= ? and tipoventa_id = ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","3")
    
           for sal in @ventas
             
              
              @ventasdetail=  FacturaDetail.select("sum(quantity) as quantity",:product_id).where(:factura_id=>sal.id,:product_id => producto).group(:product_id)
    
              for detail in @ventasdetail 
    
             
                 ret += detalle.cantidad.round(6)
      

              end 
            
           end 

     return ret
 
  end 



  def  get_ventas(fecha,producto) 
     

         ret=0  
         
      facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","#{producto}" ])
     
      if facturas
      
         for detalle in facturas
    
              ret += detalle.cantidad.round(6)
      
         end 
     end 




     @ventas  = Factura.where('fecha>= ? and fecha <= ? and tipoventa_id = ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","3")
    
           for sal in @ventas
             
              
              @ventasdetail=  FacturaDetail.select("sum(quantity) as quantity",:product_id).where(:factura_id=>sal.id,:product_id => producto).group(:product_id)
    
              for detail in @ventasdetail 
    
             
                 ret += detalle.cantidad.round(6)
      

              end 
            
           end 

     return ret
 
  end 
######



def  get_ventas_urea(fecha) 
     

    ret = 0 
    
 facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0983" ])

 if facturas
 
    for detalle in facturas

         ret += detalle.cantidad.round(6)
 
    end 
end 
   
facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0000000000938" ])

if facturas

   for detalle in facturas

        ret += detalle.cantidad.round(6)

   end 
end 


return ret

end 



def  get_ventas_urea_soles(fecha) 
     

    ret = 0 
    
 facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0983" ])

 if facturas
 
    for detalle in facturas

         ret += detalle.importe.to_f.round(6)
 
    end 
end 
   
facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0000000000938" ])

if facturas

   for detalle in facturas

        ret += detalle.cantidad.round(6)

   end 
end 


return ret

end 


    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Varillaje.create! row.to_hash 
        end
      end    

  ####
 def  get_ventas_22(fecha,producto) 

    
    puts "get_ventas_22 ******************************************************-------------- "
    puts producto

     

     ret=0  
         
      facturas = Ventaisla.where(["fecha >= ? and fecha <= ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
      if facturas
      
         for detalle in facturas
             
              @ventasdetail=  VentaislaDetail.select("sum(quantity) as quantity",:product_id).where(:ventaisla_id=>detalle.id,:product_id => producto).group(:product_id)
    
              for detail in @ventasdetail 
             
                 ret += detail.quantity.round(6)
      
              end 
      
         end 
     end 

     return ret 



  end 

 def  get_ventas_23(fecha,producto) 
     

     ret=0  
         
      facturas = Ventaisla.where(["fecha >= ? and fecha <= ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     
      if facturas
      
         for detalle in facturas
             
              @ventasdetail=  VentaislaDetail.select("sum(total) as importe",:product_id).where(:ventaisla_id=>detalle.id,:product_id => producto).group(:product_id)
    
              for detail in @ventasdetail 

             
                 ret += detail.importe.round(6)

      
              end 
      
         end 
     end 


   if producto == 89
        
        facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0983" ])

        if facturas
         
            for detalle in facturas

                 ret += detalle.importe.to_f.round(6)
         
            end 
        end 
           
        facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0000000000938" ])

        if facturas

           for detalle in facturas

                ret += detalle.importe.to_f.round(6)

           end 
        end 

   end 

     return ret 



  end 



def  get_ventas_urea_soles(fecha) 
     

    ret = 0 
    
 facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0983" ])

 if facturas
 
    for detalle in facturas

         ret += detalle.importe.to_f.round(6)
 
    end 
end 
   
facturas = Sellvale.where(["fecha >= ? and fecha <= ? and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59","0000000000938" ])

if facturas

   for detalle in facturas

        ret += detalle.importe.to_f.round(6)

   end 
end 


return ret

end 


 def  get_salidas(fecha1,fecha2,producto) 

     facturas = Output.where(["fecha >= ? and fecha <= ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
     ret=0  
     
     if facturas
     
    
     
        for factura in facturas
                factura_detalle = OutputDetail.where(["output_id = ? and product_id = ? " , factura.id,producto ])
                for detalle in factura_detalle
                    ret += detalle.quantity.round(2)
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
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 def  get_ventas_contometros0(fecha1)
         
           facturas = Sellvale.where(["fecha >= ? and fecha <= ? " , "#{fecha1} 00:00:00","#{fecha1} 23:59:59" ])
           
           if facturas
               
              ret=0  
              for detalle in facturas
                  ret += detalle.importe.to_f
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

 def  get_ventas_contometros_efectivo0(fecha1) 
     ret=0  
           facturas = Tirad.where(["fecha >= ? and fecha <= ? " , "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
           
           if facturas
             
              for detalle in facturas
                  ret += detalle.importe
             end 
          end 
    
          return ret
       
       end 


        def  get_ventas_contometros_efectivo_market(fecha) 
      
              ret=0  
         facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id <> 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ])

           if facturas
             
              for detalle in facturas
                  ret += detalle.importe.to_f 
             end 
          end 


         facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 5 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ])

           if facturas
            
              for detalle in facturas
                  ret -= detalle.importe.to_f 
             end 
          end 
    
          return ret
    



         facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id <> 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ])

           if facturas
               
              ret=0  
              for detalle in facturas
                  ret += detalle.importe.to_f 
             end 
          end 
    
          return ret
          return ret


       
       end


        def  get_ventas_contometros_efectivo_comb(fecha) 

            ret = 0 
    
         facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ])

           if facturas
               
            
              for detalle in facturas
                  ret += detalle.importe.to_f 
             end 
          end 
    
     


         facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 5 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ])

           if facturas
               
        
              for detalle in facturas
                  ret += detalle.importe.to_f 
             end 
          end 
    
          return ret
       
       end 
       

 def  get_ventas_contometros_producto_todo(fecha,producto) 
     #no incluye ventas directas

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_prod = ? and tipo <> ?   " , "#{fecha} 00:00:00","#{fecha} 23:59:59",producto,"3"])
     
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

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ?  and cod_prod = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3",producto ])
     
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
  facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ?  
     and cod_tar = ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","98"])


     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f
       end 

    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_efectivo_sustento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_tar  = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "98" ]).order(:serie,:numero)
     
     
    return facturas
 
 end 
  
 
 def  get_ventas_contometros_tarjeta_sustento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_tar = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "05" ]).order(:serie,:numero)
     
     
    return facturas
 
 end 
 
 def  get_ventas_tarjeta_sustento(fecha) 

     facturas = Factura.where(["fecha >= ? and fecha <= ?  and tarjeta_id <> 1 and serie = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "BB04"]).order(:serie,:numero)
     
     
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
 def  get_ventas_contometros_tarjeta0(fecha) 
    ret = 0 

    facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","05" ])
     
     

    
  
     if facturas
         

        for detalle in facturas
            ret += detalle.importe.to_f
       end 
    end 

    return ret
 
 end 
 
 
 def  get_ventas_contometros_tarjeta_factura(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago <> ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"F","1"])
     ret=0  
     
     if facturas
         
        
        for detalle in facturas
            ret += detalle.implista - detalle.importe.to_f 
       end 
    end 

    return ret
 
 end 
 #venta descuentos 
 def  get_ventas_contometros_descuento_factura_efe(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?   and tipo = ? and implista > 0 " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ])
     ret=0  
     
     if facturas
         
        
        for detalle in facturas
            ret += detalle.implista - detalle.importe.to_f 
       end 
    end 

    return ret
 
 end 

 def  get_ventas_contometros_descuento_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?   and tipo = ? and implista > 0 " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ])
     
    
    return facturas 
 
 end 


  def  get_ventas_contometros_descuento_factura_efe2(fecha,empleado) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?   and tipo = ? and implista > 0 and cod_emp = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,empleado ])
     ret=0  
     
     if facturas
         
        
        for detalle in facturas
            ret += detalle.implista - detalle.importe.to_f 
       end 
    end 

    return ret
 
 end 
 
  def  get_ventas_adelantada(fecha) 

     facturas = Factura.where(["fecha >= ? and fecha <= ?  and tipoventa_id = 3 " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
     return facturas 
 
 end 
 
 
 
 
 
 
 def  get_ventas_contometros_creditos(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and td = ? and cod_tar = ? 
     and  sellvales.cod_cli <> ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","06" ,"00000000090"])
     
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

         


       end 
    end 

    return ret
 
 end 


 def  get_ventas_combustibles_creditos(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and td = ? and cod_tar = ?
     and cod_cli <> ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","06","00000000090" ])
     
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

       end 
    end 

    return ret
 
 end 

 def  get_ventas_contometros_efectivos(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ? 
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","98" ])
     
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

       


       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_creditos_productos(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 3 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ?
      and cod_cli <> ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","06","00000000090" ])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f  
       end 
    end 

    return ret
 
 end 


  def  get_ventas_contometros_creditos_productos0(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id <> 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
      and cod_tar = ?
      and cod_cli <> ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","06","00000000090" ])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f  
       end 
    end 

    return ret
 
 end 


 def get_other_incomes(fecha)

    ret = 0 

  @otros =  OtherIncome.where(["fecha >= ? and fecha <= ?","#{fecha} 00:00:00","#{fecha} 23:59:59"]).sum(:importe)




 
    return @otros 
     
 end
 
 def  get_ventas_contometros_tarjeta_productos(fecha) 
     
      ret=0  

   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 3 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","05" ])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
       
        for detalle in facturas
            ret += detalle.importe.to_f  
       end 
    end 

    return ret
 
 end 


 def  get_ventas_contometros_creditos_urea(fecha) 
     
   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 5
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ? 
     and cod_cli <> ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","06" ,"00000000090"])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f  
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_contometros_tarjeta_urea(fecha) 
     
      ret=0  

   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 5
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","05" ])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
       
        for detalle in facturas
            ret += detalle.importe.to_f  
       end 
    end 

    return ret
 
 end 

 def  get_ventas_contometros_calibracion(fecha) 
     
      ret=0  

   facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ?
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59","07" ])
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     if facturas
         
       
        for detalle in facturas
            ret += detalle.importe.to_f  
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
 
 def get_faltante(fecha)

    ret = 0

    facturas =  Faltante.where(["fecha >= ? and fecha <= ? and tipofaltante_id = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59","2" ])

     if facturas
         
        for detalle in facturas
          
            ret += detalle.total.round(2)
         

        
       end 
       puts "faltante"
       puts ret 
     end 

    return ret
     

 end 

 def get_sobrante(fecha)
 ret = 0

    facturas =  Faltante.where(["fecha >= ? and fecha <= ?  and tipofaltante_id = ?"  , "#{fecha} 00:00:00","#{fecha} 23:59:59","1" ])

     if facturas
         
        for detalle in facturas
          
            ret += detalle.total.round(2)
         
        
       end 

        puts "sobrante "
       puts ret 

     end 

    return ret



 end 


  def  get_ventas_contado_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2" ]).order(:serie,:numero)

    return facturas
 
 end 
 
 def  get_ventas_directa_detalle(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ]).order(:cod_prod,:serie,:numero)

    return facturas
 
 end 
 
 def  get_ventas_directa_detalle2(fecha1,fecha2) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "N","3" ]).order(:cod_prod,:fecha,:serie,:numero)

    return facturas
 
 end 
 
 
 def  get_ventas_directa_detalle3(fecha1,fecha2) 

     facturas = Factura.where(["fecha >= ? and fecha <= ?  and document_id = ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "2" ]).order(:fecha,:serie,:numero)

    return facturas
 
 end 
 
 
 
 
 def  get_ventas_contometros_descuento(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ])
     
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
 
 def  get_ventas_contometros_descuento_facturas(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and fpago = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "F","1" ])
     ret = 0
     if facturas
         
        for detalle in facturas
            if detalle.implista > 0
            ret += detalle.implista - detalle.importe.to_f
         
          end
       end 
    end 

    return ret
 
 end 



 def  get_saldo_final_combustible(fecha2,producto,producto1,producto2)
     
     
   parts = fecha2.split("-")
   
   
   anio = parts[0] 
   mes = parts[1]
   
   
   fecha1 = parts[0]  << "-" << parts[1]  << "-01" 
   puts "fecha 1"
  
   
   #Ventas 
   saldo_final = 0 
   $i = 1
   $num = parts[2].to_i 
   
   fechax= fecha1.to_date 
   puts "inicial "
   puts fechax
   
   
   until $i > $num  do
    puts("Inside the loop i = #$i" )
    puts "fecha x" 
    puts fechax     
       wvar  = Varillaje.find_by(["fecha >= ? and fecha<=? and tanque_id = ?", "#{fechax} 00:00:00","#{fechax} 23:59:59",producto2]) 
       
       if wvar == nil    
           inicial = 0
           varilla =0
           dife = 0
       else 
           inicial = wvar.inicial 
           varilla = wvar.varilla 

         if  (producto  == 6   and fecha.to_date <= '2022-08-27'.to_date ) 

           compras = self.get_ticket_glp(fechax)
           
            else 


        
                 if (producto == 6 )

                  compras = self.get_compras20(fechax,producto)

                 else
                      

                   compras = self.get_compras21(fechax,producto)
                      


                end 



         end 

         if  producto  != 89    
             ventas_qty = self.get_ventas_22(fechax,producto)
         else 
            ventas_qty = self.get_ventas_urea(fechax) 
         end


            afericion = self.get_afericion_total_dia_producto_qty(fechax,producto2)
            saldo =  inicial + compras - ventas_qty + afericion 
            dife =  varilla - saldo 
            
                
          end 
        
     puts "saldo final  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
     puts saldo_final     
    saldo_final += dife 
    fechax = fechax.to_date + 1.day 
    $i +=1;
   end 
     
    return  saldo_final 
        

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
 
 def get_customer_payments_detalle(id) 
     @detalle = CustomerPaymentDetail.where(customer_payment_id: id)
     return @detalle
     
 end 
 
 def get_customer_payments_3(fecha1)
     @facturas =  CustomerPayment.where(['fecha1>= ? and fecha1 <= ?', "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
     
     
     return @facturas 
 end  
    
     
 def  get_ventas_vale_contado(fecha) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2" ])
     ret=0  
     if facturas
         
        
        for detalle in facturas
             ret += detalle.importe.to_f
        
       end 
    end 

    return ret
 
 end 
 
 def  get_ventas_vale_directo_producto(fecha,producto,value) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  and cod_prod  = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3",producto ])
     ret = 0
     if facturas
         

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
 
 
 def  get_ventas_vale_directo_producto2(fecha1,fecha2,producto,value) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  and cod_prod  = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "N","3",producto ])
     ret = 0
     if facturas

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

 
 def  get_ventas_vale_adelanto_producto(fecha,producto,value) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  and cod_prod  = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","4",producto ])
     ret=0  
     if facturas
         
        
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
 def  get_ventas_vale_directo2(fecha1,fecha2) 

     facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "N","3" ])
     
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
 
 def get_afericion_total_dia_producto_qty(fecha,producto)
     
     facturas = Afericion.where(["fecha >= ? and fecha <= ?  and tanque_id = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",producto ])
       ret = 0  
       
     if facturas
         
       for detalle in facturas
          ret += detalle.quantity
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
     
     facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 3
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ?  
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59"])
     
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

       


       end 
    end 

    return ret

 end


 def get_ventas_urea0(fecha)
     
     facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id = 5
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ?  
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59"])
     
     
  #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
     
     
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

       


       end 
    end 

    return ret

 end
 
 def get_ventas_market_tarjeta(fecha)
     tarjeta = "05"
    facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
     INNER JOIN products ON sellvales.cod_prod = products.code 
     WHERE products.products_category_id <> 1 
     and sellvales.fecha >= ? 
     and sellvales.fecha <= ? 
     and cod_tar = ?  
     ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59",tarjeta ])
     
        
     if facturas
         
        ret=0  
        for detalle in facturas
            ret += detalle.importe.to_f 

       

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
            
             if detalle.product.products_category_id == 5
                    ret += detalle.total 
             end 
          end 
          
       end 
       
     end 
     
     return ret 
 end 
 
 def get_ventas_restaurant_tarjeta(fecha)
     
     facturas = Factura.where(["fecha >= ? and fecha <= ?  and tarjeta_id <> 1 " , "#{fecha} 00:00:00","#{fecha} 23:59:59" ])
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

 def get_ventas_colaterales_efe(fecha,tipo )
      ret = 0
     facturas = VentaProducto.where(["fecha >= ? and fecha <= ? and  division_id = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59",tipo ])
      
       if facturas
       for factura in facturas
        ret += factura.total_efe  
       end 
     end 
     
     return ret 
 end  
 
 def get_ventas_colaterales_tar(fecha,tipo )
     ret = 0
     facturas = VentaProducto.where(["fecha >= ? and fecha <= ? and division_id = ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59",tipo])
      
       if facturas
         
       for factura in facturas
         
         
        ret += factura.total_tar 
        
          
       end 
       
     end 
     
     return ret 
 end  
 
 
 def get_deposito(fecha)
     
      
     depositos = Deposito.where(["fecha_parte >= ? and fecha_parte <= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59"])
      
     return depositos
     
 end 
 
 def get_gastos_varios(fecha )
     
     ret = 0
     facturas = Expense.where(["fecha >= ? and fecha <= ? " , "#{fecha} 00:00:00","#{fecha} 23:59:59"])
      
     if facturas
         
       for factura in facturas
            ret += factura.importe 
       end 
       
     end 
     
     return ret 
 end  
 
 def  get_ingresos(fecha1,product  ) 
      
        ret = 0 
        @purchases1 = Purchase.joins(:purchase_details).
        select("sum(purchase_details.quantity) as quantity").
        group("purchases.date2").order("purchases.date2").
        where("purchases.date2>=? and purchases.date2<=? and purchase_details.product_id=?","#{fecha1} 00:00:00","#{fecha1} 23:59:59","#{product}" )
       
      if   @purchases1.first == nil  || @purchases1.blank? || @purchases1.empty? 
         return ret 

      else 
       
        puts "retorno ******************"
        ret += @purchases1.first.quantity 
          return ret 
    
      end 



 end 


       def get_varilla(fecha1,fecha2,tanque ) 

          ret = 0
       
           @varilla = Varillaje.where(["fecha >= ? and fecha <= ?  and tanque_id = ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,tanque  ]).order(:tanque_id,:fecha)
            if @varilla
            ret = @varilla  
                return ret
            else
                return ret 
            end 
       end

       def get_saldo_inicial(fecha1,fecha2,tanque ) 

          ret = 0
       
           @varilla = Varillaje.where(["fecha >= ? and fecha <= ?  and tanque_id = ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,tanque  ]).order(:tanque_id,:fecha)
            if @varilla
            ret = @varilla  
                return ret
            else
                return ret 
            end 
       end

     
     

    # def  get_ventas(fecha,product ) 

    #         ret = 0

    #         facturas  = 0

    #          facturas = Sellvale.find_by_sql(['Select SUM(cantidad) AS total 
    #                      from sellvales where fecha >= ? and fecha <= ? and cod_prod=? and fpago <> ?' , "#{fecha} 00:00:00","#{fecha} 23:59:59",product,"07"])

    #         if facturas.first.total != nil  
    #             puts "aaaaa"
    #             ret += facturas.first.total  
                           
    #         end                
            
    #        @facturas = Factura.find_by_sql(['Select facturas.*,customers.id,customers.name 
    #                    from facturas 
    #                    INNER JOIN customers ON facturas.customer_id = customers.id   
    #                    WHERE facturas.fecha >= ? and facturas.fecha <= ? and customers.tipo = ? ', "#{fecha} 00:00:00",
    #                    "#{fecha} 23:59:59","4" ])              

    #        # @facturas  = Factura.select("Facturas.*,customers.id as customer_id").where(["fecha >= ? and fecha <= ? and cod_prod = ? ",
    #        #  "#{fecha} 00:00:00","#{fecha} 23:59:59", product   ]).order(:fecha).joins("INNER JOIN customers ON 
    #        #   facturas.customer_id = customers.id
    #        #   AND customers.tipo = '4'  ")
             
    #        if @facturas
                   
    #              puts "venta mayorista " 

    #               for detalle in @facturas
    #                 puts "detalle----"    
    #                 puts detalle.id 
                  
    #                    @factura_details = FacturaDetail.where(factura_id: detalle.id , product_id: 5 )
                   
    #                     for quote in   @factura_details 
                 
    #                          ret += quote.quantity 
    #                          puts "factura detaleee..."
    #                          puts ret

    #                     end 
    #              end  
              
    #         end 


    #     return ret 

    # end




  def  get_ventas_serafin(fecha,product ) 

            facturas  = 0

             facturas = Sellvale.find_by_sql(['Select SUM(cantidad) AS total 
                         from sellvales where fecha >= ? and fecha <= ? and cod_prod=? and fpago=  ?' , "#{fecha} 00:00:00","#{fecha} 23:59:59",product,"07"])

            if facturas.first.total != nil  
                puts "aaaaa"
                puts facturas.first.total  
              return facturas.first.total  
            else 
               return 0
            end                
            
  end
 def self.to_csv(options = {})
      CSV.generate(options) do |csv|
      csv << column_names
      all.each do |customer|
        csv << customer.attributes.values_at(*column_names)
      end
    end   
    end 
 



 
end
