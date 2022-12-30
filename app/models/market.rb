class Market < ActiveRecord::Base
    
 validates_presence_of :fecha, :turno,:td,:caja,:serie,:numero,:cod_cli,:cantidad,:precio,:td,:fpago,:cod_prod 
 

    
    def self.import(file)
        
        
       CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['cod_prod'] =  row['cod_prod'].rjust(13, '0')  
           
           if row['cod_cli'] != nil
            row['cod_cli'] =  row['cod_cli'].rjust(11, '0')  
           else
            row['cod_cli'] =  "C_000001"
           end 
           
           row['processed'] = "0"
           
           Market.create! row.to_hash 
           
         end 
         
         
    end     


def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
  where("numero  iLIKE ? or cod_cli iLIKE ? ", "%#{search}%","%#{search}%")
end    

def get_cliente(cliente)
     a= Customer.find_by(account: cliente)
     
    if a
         return a.name
    else
        return "Cliente no existe"
    end 
 end 
 def get_product_name(codigo) 
      
      a=Product.find_by(code: codigo)
      
      if a
          
          return a.name 
      else 
          return "Nombre no existe..."
          
      end 
    
  end    
    
     def process2
       

         @factura =   Market.select(:fecha, :serie,:numero,"SUM(cantidad) as quantity","SUM(importe) as total").where("fecha>=? and fecha<=? and td = ? ","2022-12-01 00:00:00","2022-12-31 23:59:59","B").group(:fecha,:serie,:numero )
    
    #   @factura =   Market.select(:fecha, :serie,:numero,"SUM(cantidad) as quantity","SUM(importe) as total").where("numero >=? and numero<=? and td = ?","007180","007593","B").group(:fecha,:serie,:numero )
     

    for item_factura in @factura



          @fecha_emision = item_factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = item_factura.fecha.strftime("%Y-%m-%d")
         

         @lcsubtotal  = item_factura.total  / 1.18 
         @lctax       = item_factura.total - @lcsubtotal 




            @forma_pago = "CONTADO" 
            @medio_pago = "EFECTIVO"
        
        
          @serie  =  item_factura.serie
          @numero =  item_factura.numero 

       
           @moneda_nube = 1
        
         
                @texto_obs =  " "
            puts "*"
              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "2",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                "cliente_tipo_de_documento"            => "-",
                "cliente_numero_de_documento"       => "0",
                "cliente_denominacion"              => "CLIENTE GENERICO",
                "cliente_direccion"                 => "" ,
                  "cliente_email"                     => "" ,
                  "cliente_email_1"                   => "",
                  "cliente_email_2"                   => "",
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => @fecha_vmto ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.839",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => @lcsubtotal.round(2),
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => @lctax.round(2),
                  "total_gratuita"                    => "",
                  "total_otros_cargos"                => "",
                  "total"                             => item_factura.total.round(2),
                  "percepcion_tipo"                   => "",
                  "percepcion_base_imponible"         => "",
                  "total_percepcion"                  => "",
                  "total_incluido_percepcion"         => "",
                  "detraccion"                        => "false",
                  "observaciones"                     => @texto_obs, 
                  "documento_que_se_modifica_tipo"    => "",
                  "documento_que_se_modifica_serie"   => "",
                  "documento_que_se_modifica_numero"  => "",
                  "tipo_de_nota_de_credito"           => "",
                  "tipo_de_nota_de_debito"            => "",
                  "enviar_automaticamente_a_la_sunat" => "true",
                  "enviar_automaticamente_al_cliente" => "true",
                  "codigo_unico"                      => "",
                  "condiciones_de_pago"               => @forma_pago,
                  "medio_de_pago"                     => @medio_pago,
                  "placa_vehiculo"                    => ""  ,
                  "orden_compra_servicio"             => "",
                  "tabla_personalizada_codigo"        => "",
                  "formato_de_pdf"                    => "",
                   "detraccion_tipo"                  => "",
                   "detraccion_total"                 => "",
                   "medio_de_pago_detraccion"         => ""
                 
              })






# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0


@factura_detail = Market.where(serie:  @serie ,numero: @numero )
      
     

for detail_boleta in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts detail_boleta.cantidad 
#puts item_factura.preciosigv 

        
          @valor_unitario = (detail_boleta.importe / detail_boleta.cantidad ) / 1.18 
          invoice.add_item({
            codigo: detail_boleta.cod_prod ,
           unidad_de_medida: "NIU", 
          descripcion: detail_boleta.name  ,
          cantidad: detail_boleta.cantidad,
          valor_unitario:  @valor_unitario  ,
          tipo_de_igv: 1 

          })

    

end 





puts JSON.pretty_generate(invoice )

result = invoice.deliver

    if result['errors'] 
        puts  "#{result['codigo']}: #{result['errors']}  aviso"
        self.msgerror = "#{result['codigo']}: #{result['errors']}  aviso"
      else 
        self.msgerror = "Factura en nubefact."

    end

        self.processed="1"
   
        self.date_processed = Time.now
        self.save

    
end 

    
end

#########################################################

def process3
       

    @factura =   Market.select(:fecha, :serie,:numero,:ruc,:razon_social, :address,"SUM(cantidad) as quantity","SUM(importe) as total").where("fecha>=? and fecha<=? and td = ?","2022-12-01 00:00:00","2022-12-31 23:59:59","F").group(:fecha,:serie,:numero,:ruc,:razon_social, :address )
    
     

    for item_factura in @factura



          @fecha_emision = item_factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = item_factura.fecha.strftime("%Y-%m-%d")
         

         @lcsubtotal  = item_factura.total  / 1.18 
         @lctax       = item_factura.total - @lcsubtotal 




            @forma_pago = "CONTADO" 
            @medio_pago = "EFECTIVO"
        
        
          @serie  =  item_factura.serie
          @numero =  item_factura.numero 

       
           @moneda_nube = 1
        
         
                @texto_obs =  " "
            puts "*"
              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "1",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                  "cliente_tipo_de_documento"         => "6",
                  "cliente_numero_de_documento"       => item_factura.ruc ,
                  "cliente_denominacion"              => item_factura.razon_social,
                  "cliente_direccion"                 => item_factura.address  ,
                  "cliente_email"                     => "" ,
                  "cliente_email_1"                   => "",
                  "cliente_email_2"                   => "",
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => @fecha_vmto ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.839",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => @lcsubtotal.round(2),
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => @lctax.round(2),
                  "total_gratuita"                    => "",
                  "total_otros_cargos"                => "",
                  "total"                             => item_factura.total.round(2),
                  "percepcion_tipo"                   => "",
                  "percepcion_base_imponible"         => "",
                  "total_percepcion"                  => "",
                  "total_incluido_percepcion"         => "",
                  "detraccion"                        => "false",
                  "observaciones"                     => @texto_obs, 
                  "documento_que_se_modifica_tipo"    => "",
                  "documento_que_se_modifica_serie"   => "",
                  "documento_que_se_modifica_numero"  => "",
                  "tipo_de_nota_de_credito"           => "",
                  "tipo_de_nota_de_debito"            => "",
                  "enviar_automaticamente_a_la_sunat" => "true",
                  "enviar_automaticamente_al_cliente" => "true",
                  "codigo_unico"                      => "",
                  "condiciones_de_pago"               => @forma_pago,
                  "medio_de_pago"                     => @medio_pago,
                  "placa_vehiculo"                    => ""  ,
                  "orden_compra_servicio"             => "",
                  "tabla_personalizada_codigo"        => "",
                  "formato_de_pdf"                    => "",
                   "detraccion_tipo"                  => "",
                   "detraccion_total"                 => "",
                   "medio_de_pago_detraccion"         => ""
                 
              })






# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0


@factura_detail = Market.where(serie:  @serie ,numero: @numero )
      
     

for detail_boleta in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts detail_boleta.cantidad 
#puts item_factura.preciosigv 

        
          @valor_unitario = (detail_boleta.importe / detail_boleta.cantidad ) / 1.18 
          invoice.add_item({
            codigo: detail_boleta.cod_prod ,
           unidad_de_medida: "NIU", 
          descripcion: detail_boleta.name  ,
          cantidad: detail_boleta.cantidad,
          valor_unitario:  @valor_unitario  ,
          tipo_de_igv: 1 

          })

    

end 





puts JSON.pretty_generate(invoice )

result = invoice.deliver

    if result['errors'] 
        puts  "#{result['codigo']}: #{result['errors']}  aviso"
        self.msgerror = "#{result['codigo']}: #{result['errors']}  aviso"
      else 
        self.msgerror = "Factura en nubefact."

    end

        self.processed="1"
   
        self.date_processed = Time.now
        self.save

    
end 





    
end

######################################################33#




 
     def process4
       

         @factura =   Market.select(:fecha, :serie,:numero,"SUM(cantidad) as quantity","SUM(importe) as total").where("fecha>=? and fecha<=? and td = ? and cod_tar=?","2022-12-01 00:00:00","2022-12-31 23:59:59","B","11").group(:fecha,:serie,:numero )

    #   @factura =   Market.select(:fecha, :serie,:numero,"SUM(cantidad) as quantity","SUM(importe) as total").where("numero >=? and numero<=? and td = ?","007180","007593","B").group(:fecha,:serie,:numero )
     

    for item_factura in @factura



          @fecha_emision = item_factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = item_factura.fecha.strftime("%Y-%m-%d")
         

         @lcsubtotal  = item_factura.total  / 1.18 
         @lctax       = item_factura.total - @lcsubtotal 




            @forma_pago = "RETIRO POR PREMIO" 
            @medio_pago = "TRANSFERENCIA GRATUITA"
        
        
          @serie  =  item_factura.serie
          @numero =  item_factura.numero 

       
           @moneda_nube = 1
        
         
                @texto_obs =  " "
            puts "*"
              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "2",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                "cliente_tipo_de_documento"            => "-",
                "cliente_numero_de_documento"       => "0",
                "cliente_denominacion"              => "CLIENTE GENERICO",
                "cliente_direccion"                 => "" ,
                  "cliente_email"                     => "" ,
                  "cliente_email_1"                   => "",
                  "cliente_email_2"                   => "",
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => "" ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.839",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => "",
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => "",
                  "total_gratuita"                    => @lcsubtotal.round(2),
                  "total_otros_cargos"                => "",
                  "total"                             => "0",
                  "percepcion_tipo"                   => "",
                  "percepcion_base_imponible"         => "",
                  "total_percepcion"                  => "",
                  "total_incluido_percepcion"         => "",
                  "detraccion"                        => "false",
                  "observaciones"                     => @texto_obs, 
                  "documento_que_se_modifica_tipo"    => "",
                  "documento_que_se_modifica_serie"   => "",
                  "documento_que_se_modifica_numero"  => "",
                  "tipo_de_nota_de_credito"           => "",
                  "tipo_de_nota_de_debito"            => "",
                  "enviar_automaticamente_a_la_sunat" => "true",
                  "enviar_automaticamente_al_cliente" => "true",
                  "codigo_unico"                      => "",
                  "condiciones_de_pago"               => @forma_pago,
                  "medio_de_pago"                     => @medio_pago,
                  "placa_vehiculo"                    => ""  ,
                  "orden_compra_servicio"             => "",
                  "tabla_personalizada_codigo"        => "",
                  "formato_de_pdf"                    => "",
                   "detraccion_tipo"                  => "",
                   "detraccion_total"                 => "",
                   "medio_de_pago_detraccion"         => ""
                 
              })






# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0


@factura_detail = Market.where(serie:  @serie ,numero: @numero )
      
     

for detail_boleta in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts detail_boleta.cantidad 
#puts item_factura.preciosigv 
        
          @valor_unitario = (detail_boleta.importe / detail_boleta.cantidad ) / 1.18 
          invoice.add_item2({
            codigo: detail_boleta.cod_prod ,
           unidad_de_medida: "NIU", 
          descripcion: detail_boleta.name  ,
          cantidad: detail_boleta.cantidad,
          valor_unitario:  @valor_unitario  ,
          precio_unitario: @valor_unitario,
          descuento: "",
          subtotal: @valor_unitario,
          tipo_de_igv: 6,
          igv: "0",
          total: @valor_unitario


          })

    

end 





puts JSON.pretty_generate(invoice )

result = invoice.deliver

    if result['errors'] 
        puts  "#{result['codigo']}: #{result['errors']}  aviso"
        self.msgerror = "#{result['codigo']}: #{result['errors']}  aviso"
      else 
        self.msgerror = "Factura en nubefact."

    end

        self.processed="1"
   
        self.date_processed = Time.now
        self.save

    
end 

    
end

#########################################################

end 
