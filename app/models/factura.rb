class Factura < ActiveRecord::Base
  self.per_page = 20


  validates_presence_of :company_id, :customer_id, :code, :user_id,:fecha

  validates :code , uniqueness:{ scope:[:customer_id, :document_id,:moneda_id]}

  validates_presence_of :documento2,  if: -> { self.document_id == '2' }

  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :customer
  belongs_to :payment 
  belongs_to :user
  belongs_to :moneda 
  belongs_to :document
  belongs_to :tipoventa 
  belongs_to :tarjetum 
  belongs_to :anexo8  


  has_many   :deliveryship
  has_many   :delivery 
  has_many   :invoice_services
  has_many   :customer_payment_details
  has_many   :factura_details 
  
   TABLE_HEADERS = ["TD",
                      "Documento",
                     "Fecha",
                     "Cliente",
                     "Moneda",
                     "",
                     "subtotal",
                     "IGV.",
                     "TOTAL",
                     "ESTADO"]

  TABLE_HEADERS2 = ["TD",
                      "Documento",
                     "Fec.Emision",
                     "Fec.Vmto",
                     "Dias",
                     "Dias
                     
                      Vencido",
                     "C L I E N T E ",
                     "Pre.",
                     "Cant.",
                     "Mon. ",
                     "Imp. Original
                     Soles",
                     "Imp. Original
                      Dolares",
                     "Soles",
                     "Dolares",
                     "Detraccion",
                     "Vencido."]
                     
  TABLE_HEADERS3 = ["TD",
                      "Documento",
                     "Fecha",
                     "Fec.Vmto",
                     "Dias ",
                     "Cliente",
                     "Moneda",                                         
                     "SOLES",
                     "DOLARES ",
                     "DETRACCION",
                     "OBSERV"]
  TABLE_HEADERS_TK = ["Cant.",
                      "Codigo",
                     "Descripcion",
                     "V.Unit.",
                     "Total" ]
                     

 

 def get_maximo(serie,documento)

    case 

     when serie == "1"

      @serie = "FFF1"

     when serie == "2"

      @serie = "FF01"
 
     when serie == "3"

      @serie = "FF02"

     when serie == "4"

      @serie = "FF03"

     when serie == "5"

      @serie = "FF04"
     when serie == "6"

      @serie = "FF05"

     when serie  == "7"

      @serie = "FF06"


     end 


   #  options_for_select([["FFF1",1],["FF01",2],["FF02",3],["FF03",4],["FF04",5],["FF05",6],["FF06",7]], params[:option] ), class:"select") %>
     




    a= Factura.where("SUBSTRING(code,1,4) = ? and document_id = ?", @serie,documento).maximum("cast(substring(code,6,11) as int)")
       if a.nil?
        return  @serie + "-000001"
      else
        return  @serie  + "-"+ (a + 1).to_s.rjust(6, '0') 

      end 
 end 

 def   self.to_csv(result)
    unless result.nil?
      CSV.generate do |csv|
        csv << result[0].attributes_names
        result.each do |row|
          csv << row.attributes.values
        end
      end
    end   
  end

  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Factura.create! row.to_hash 
        end
  end      


  def get_dias_formapago
    
    return self.payment.day 
    
  end   


  def factura_es_pagada?



             if CustomerPaymentDetail.where(factura_id: self.id).exists?

                @pago = CustomerPaymentDetail.where(factura_id: self.id).last 

               

                if CustomerPayment.where(id: @pago.customer_id , processed: "1" ).exists?

                   @pago_existe = CustomerPayment.where(id: @pago.customer_id , processed: "1" ).last

                  return true 

                else 

                  return false

                end 

              else 

                return false 



             end 
    
  end
    
  def get_vencido

      if(self.fecha2 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

  end 

  def my_deliverys
        @deliveryships = Delivery.all 
        return @deliveryships
  end 

  def correlativo      
        numero = Voided.find(2).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'2').update_all(:numero =>lcnumero)        
  end
  def correlativo2
        numero = Voided.find(15).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'15').update_all(:numero =>lcnumero)        
  end


  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_f
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_tax(items, customer_id)
    tax = 0
    
    customer = Customer.find(customer_id)
    
    if(customer)
      if(customer.taxable == "1")
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            price = parts[2]
            discount = parts[3]
        
            total = price.to_f * quantity.to_f
            total -= total * (discount.to_f / 100)
        
            begin
              product = Product.find(id.to_i)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end
                
              end
            rescue
            end
          end
        end
      end
    end
    
    return tax
  end

 def get_total_1(items)
    total0 = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2] 
        discount = parts[3]
        
        total1 = price.to_f * quantity.to_f
        total = total1.round(2)
        
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          total0 += total 
          rescue
        end
      end
    end
    
    return total0
  end
  

  def get_subtotal2
  
    
    invoices = FacturaDetail.where(["factura_id = ? ", self.id ])
    ret = 0
    
    for invoice in invoices
    
          ret += invoice.total 
        
    end
   
    
    return ret
  end
  
  
  
  def delete_products()
    invoice_services = FacturaDetail.where(factura_id: self.id)
    
    for ip in invoice_services
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_f
        total -= total * (discount.to_f / 100)
        preciosigv = price.to_f / 1.18 
        
        begin
          product = Product.find(id.to_i)
          
          new_invoice_product = FacturaDetail.new(:factura_id => self.id, :product_id => product.id,:price_discount=> price.to_f, :price => price.to_f, :quantity => quantity.to_f, :discount => discount.to_f, :total => total.to_f,:preciosigv=> preciosigv)

          new_invoice_product.save

        rescue
          
        end
       
      end
    end
  end

  
  def add_guias(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        begin
          @guia = Delivery.find(id.to_i)

          @guia.processed='4'
          @guia.facturar 
          
          new_invoice_guia = Deliveryship.new(:factura_id => self.id, :delivery_id => @guia.id)          
          new_invoice_guia.save
           
        rescue
          
        end
      end
    end
  end
  

  def delete_guias()
    invoice_guias = Deliveryship.where(factura_id: self.id)
    
    for ip in invoice_guias
      ip.destroy
    end
  end
  
  def delete_facturas()
    invoice_guias = FacturaDetail.where(factura_id: self.id)
    
    for ip in invoice_guias
    
      sellvale_process =  Sellvale.where(:id => ip.sellvale_id).first
      
      if sellvale_process != nil  
        sellvale_process.processed = "0"
        if sellvale_process.save
          ip.destroy
        end 
      end 
      
    end
    
    for ip in invoice_guias 
      ip.destroy
    end
    
  end
  

  def identifier
    return "#{self.code} - #{self.customer.name}"
  end

  def get_invoices
    @facturas= Factura.find_by_sql(['Select facturas.*,customers.ruc,payments.descrip from facturas 
      LEFT JOIN customers on facturas.customer_id = customers.id 
      LEFT JOIN payments  on facturas.payment_id = payments.id'])
      return @facturas
  end 

  def get_facturas(id)
  
    @facturas= Factura.where(["balance > 0  and customer_id = ?",  id ])

    return @facturas
  end 


  
  def get_invoices_cantidad
    
    
    
      ret = 0
    invoices = FacturaDetail.where(["factura_id = ?", self.id])
    
    for invoice in invoices

        ret += invoice.quantity

    end
    
  
    
    return ret
  
    
  end 

  def get_products2(id)    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
      invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
     from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', id ])
    
    return @itemproducts
  end

  def get_products    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
    	invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
  	 from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_products_2 
    @itemproducts = FacturaDetail.find_by_sql(['Select factura_details.price,
    	factura_details.quantity,factura_details.discount,factura_details.total,products.name ,products.code 
  	 from factura_details INNER JOIN products ON factura_details.product_id = products.id where factura_details.factura_id = ?', self.id ])
    
    return @itemproducts
  end
  
   
  def get_guias    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias
  end

  def get_guiasremision 
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias1
  end
  def get_guias2(id)    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description,deliveries.processed
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', id ])
    return @itemguias
  end

  def get_guiasremision2(id)
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', id ])
    return @itemguias1
  end

  def get_guias_remision(id)    
        
    guias = []
    invoice_guias = Deliverymine.where(:mine_id => id)
    return invoice_guias
        
  end
  

  def get_invoice_products
    invoice_products = InvoiceService.where(factura_id:  self.id)    
    return invoice_products
  end
  
  def products_lines
    services = []
    invoice_products = InvoiceService.where(factura_id:  self.id)
    
    invoice_products.each do | ip |

      ip.service[:price]    = ip.price
      ip.service[:quantity] = ip.quantity
      ip.service[:discount] = ip.discount
      ip.service[:total]    = ip.total
      services.push("#{ip.service.id}|BRK|#{ip.service.quantity}|BRK|#{ip.service.price}|BRK|#{ip.service.discount}")
    end
      puts  #{ip.service.id}|BRK|#{ip.service.quantity}|BRK|#{ip.service.price}|BRK|#{ip.service.discount

    return services.join(",")
  end
  
  def guias_lines
    guias = []
    invoice_guias = DeliveryShip.where(factura_id:  self.id)
    
    invoice_guias.each do | ip |
      guias.push("#{ip.delivery.id}|BRK|")
    end    

    return guias.join(",")
  end
  
    def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  

    elsif (self.processed == "4")

      return "-Facturado --"  

    else   
      return "No Aprobado"
        
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Yes"
    elsif (self.processed == "3")
       return "Yes"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Yes"
    else
      return "No"
    end
  end
  
  
  
  def get_cantidad 
    
    a= FacturaDetail.where(factura_id: self.id)
    tot = 0
    
    a.each do | item |
        tot+= item.quantity.round(2)
    end 
    
    return tot
    
  end 



  def get_codigo_det
  
    if FacturaDetail.where(factura_id: self.id ).exists?

       a = FacturaDetail.where(factura_id: self.id )
     return   a.first.product.cuentadet 
    else
     return 0.00 
    end 
  end   


  # Process the invoice
  def process

    if(self.processed == "1" or self.processed == true)   


      self.processed="1"

       if self.servicio == "true"

        puts "processado"
        puts "xxx"
         facturas = FacturaDetail.where(factura_id: self.id)
         total = 0 
         total1 = 0
         tax0 = 0

           for x in facturas 
              total0 = 0
              x.total = (x.preciosigv.round(3) * 1.18 * x.quantity)
              total0 = x.total.round(2)
              x.save
              
              total += total0 

             end

           a = Factura.find(self.id)

           a.total = total
           
           tax0 = a.total / 1.18
           
           a.subtotal  = tax0.round(2)
           a.tax = a.total - a.subtotal 

           a.save

        end 
        
        self.date_processed = Time.now
        self.save

    end

  end

  
  # Process the invoice
  def process2
       

          Factura.where(id: self.id).update_all("fecha_cuota1 = fecha2, importe_cuota1 =  total - detraccion_importe ")
             @factura = Factura.find(self.id)

          puts @factura.code 

          @fecha_emision = @factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = @factura.fecha2.strftime("%Y-%m-%d")


          if @factura.payment.day == 0 
            @forma_pago = "CONTADO" 
            @medio_pago = "CONTADO"
          else 
             @forma_pago = "CREDITO"
             @medio_pago = "VENTA AL CREDITO"
          end



          ff = @factura.code.split("-")

          @serie  =  ff[0]
          @numero =  ff[1]

          if @factura.moneda_id == 1 
           @moneda_nube = 2
          else
           @moneda_nube = 1
          end
         
                @texto_obs = @factura.guia + " " + @factura.description 

        

          if @factura.detraccion_importe  > 0.0
            puts " ** detraccion********************************************"
            
              @detraccion_tipo  =  "35"
              
              if @factura.moneda_id == 1 
                  @detraccion_total =  @factura.detraccion_importe * @factura.get_tipocambio(@factura.fecha) 
                  

              else 
                  @detraccion_total =  @factura.detraccion_importe
              end 


              @medio_de_pago_detraccion = "1" 
              @detraccion_porcentaje = @factura.detraccion_percent


            # create a new Invoice object
            invoice = NubeFact::Invoice.new({
                "operacion"                   => "generar_comprobante",
                "tipo_de_comprobante"               => "1",
                "serie"                             =>  @serie,
                "numero"                            =>  @numero ,
                "sunat_transaction"                 => "30",
                "cliente_tipo_de_documento"         => "6",
                "cliente_numero_de_documento"       => @factura.customer.ruc ,
                "cliente_denominacion"              => @factura.customer.name ,
                "cliente_direccion"                 => @factura.customer.direccion_all ,
                "cliente_email"                     => @factura.customer.email ,
                "cliente_email_1"                   => "envio.facturas@valuemi.com.pe",
                "cliente_email_2"                   => @factura.customer.email2,
                "fecha_de_emision"                  => @fecha_emision,
                "fecha_de_vencimiento"              => @fecha_vmto ,
                "moneda"                            => @moneda_nube,
                "tipo_de_cambio"                    => @factura.get_tipocambio(@factura.fecha),
                "porcentaje_de_igv"                 => "18.00",
                "descuento_global"                  => "",
                "total_descuento"                   => "",
                "total_anticipo"                    => "",
                "total_gravada"                     => @factura.subtotal,
                "total_inafecta"                    => "",
                "total_exonerada"                   => "",
                "total_igv"                         => @factura.tax,
                "total_gratuita"                    => "",
                "total_otros_cargos"                => "",
                "total"                             => @factura.total,
                "percepcion_tipo"                   => "",
                "percepcion_base_imponible"         => "",
                "total_percepcion"                  => "",
                "total_incluido_percepcion"         => "",
                "detraccion"                        => "true",
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
                "placa_vehiculo"                    => "",
                "orden_compra_servicio"             => "",
                "tabla_personalizada_codigo"        => "",
                "formato_de_pdf"                    => "",
                "detraccion_tipo"                  => @detraccion_tipo,
                "detraccion_total"                 => @detraccion_total,
                "detraccion_porcentaje"            => @detraccion_porcentaje,
                "medio_de_pago_detraccion"         => @medio_de_pago_detraccion,
                "ubigeo_origen"                    => "",
                "direccion_origen"                 => "",
                "ubigeo_destino"                   => "",
                "direccion_destino"                =>  "",
                 "detalle_viaje"  => "",
                 "val_ref_serv_trans"  => "",
                 "val_ref_carga_efec"  => "",
                 "val_ref_carga_util"  => ""
               
            })

          else 

            puts " sin detraccion**"
              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "1",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                  "cliente_tipo_de_documento"         => "6",
                  "cliente_numero_de_documento"       => @factura.customer.ruc ,
                  "cliente_denominacion"              => @factura.customer.name ,
                  "cliente_direccion"                 => @factura.customer.direccion_all ,
                  "cliente_email"                     => @factura.customer.email ,
                  "cliente_email_1"                   => "envio.facturas@valuemi.com.pe",
                  "cliente_email_2"                   => @factura.customer.email2,
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => @fecha_vmto ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.712",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => @factura.subtotal,
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => @factura.tax,
                  "total_gratuita"                    => "",
                  "total_otros_cargos"                => "",
                  "total"                             => @factura.total,
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




          end    


# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0


@factura_detail = FacturaDetail.select(:product_id,"SUM(quantity) as quantity","SUM(total) as total").where(factura_id: self.id).group(:product_id)
      
     

for item_factura in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts item_factura.quantity  
#puts item_factura.preciosigv 

        if @factura.servicio == "true"
          invoice.add_item({
            codigo: item_factura.product.code ,
         unidad_de_medida: item_factura.product.unidad.descrip2, 
          descripcion: item_factura.product.name ,
          cantidad: item_factura.quantity,
          valor_unitario: item_factura.preciosigv.round(3)   ,
          tipo_de_igv: 1 

          })
        else 

          @valor_unitario = (item_factura.total / item_factura.quantity ) / 1.18 
          invoice.add_item({
            codigo: item_factura.product.code ,
           unidad_de_medida: item_factura.product.unidad.descrip2, 
          descripcion: item_factura.product.name ,
          cantidad: item_factura.quantity,
          valor_unitario:  @valor_unitario  ,
          tipo_de_igv: 1 

          })

        end 

end 

if @factura.importe_cuota1 > 0.00
          invoice.add_cuota({
            cuota: "1" ,
            fecha_de_pago: @factura.fecha_cuota1.strftime("%d-%m-%Y"), 
            importe: @factura.importe_cuota1 

          })

end 

if @factura.importe_cuota2 > 0.00
          invoice.add_cuota({
             cuota: "2" , 
             fecha_de_pago: @factura.fecha_cuota2.strftime("%d-%m-%Y"), 
             importe: @factura.importe_cuota2 


          })

end 
if @factura.importe_cuota3 > 0.00 
          invoice.add_cuota({
             cuota: "3" ,
            fecha_de_pago: @factura.fecha_cuota3.strftime("%d-%m-%Y"), 
            importe: @factura.importe_cuota3 ,

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

#####################################################################################################

 def process3

  puts "nota de credooooooooooooooooooooooooooo"
             
         @factura = Factura.find(self.id)

          puts @factura.code 

          @fecha_emision = @factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = @factura.fecha2.strftime("%Y-%m-%d")


          if @factura.payment.day == 0 
            @forma_pago = "CONTADO" 
            @medio_pago = "CONTADO"
          else 
             @forma_pago = "CREDITO"
             @medio_pago = "VENTA AL CREDITO"
          end


          ff = @factura.code.split("-")

          if @factura.document_id == 2              
               @serie  =  "FFF1"
          end 

        
          @numero =  ff[1]


           @nc = @factura.documento2.split("-")

           @documento_serie_a_modificar  = @nc[0]
           @documento_numero_a_modificar = @nc[1]

           @tipo_nota_credito = @factura.anexo8.code_nube


         if @factura.moneda_id == 1 
           @moneda_nube = 2
          else
                @moneda_nube = 1
          end
          @texto_obs =  ""

          lcDes = @factura.description


     
               @texto_cuentas  = ""


          if @factura.detraccion_importe  > 0.0
            puts " ** detraccion********************************************"
              @detraccion_tipo  =  "25"
              if @factura.moneda_id == 1 
                  @detraccion_total =  @factura.detraccion_importe * @factura.get_tipocambio(@factura.fecha) 
                  

              else 
                  @detraccion_total =  @factura.detraccion_importe
              end 


              @medio_de_pago_detraccion = "1" 
              @detraccion_porcentaje = @factura.detraccion_percent

            # create a new Invoice object
            invoice = NubeFact::Invoice.new({
                "operacion"                   => "generar_comprobante",
                "tipo_de_comprobante"               => "3",
                "serie"                             =>  @serie,
                "numero"                            =>  @numero ,
                "sunat_transaction"                 => "33",
                "cliente_tipo_de_documento"         => "6",
                "cliente_numero_de_documento"       => @factura.customer.ruc ,
                "cliente_denominacion"              => @factura.customer.name ,
                "cliente_direccion"                 => @factura.customer.direccion_all ,
                "cliente_email"                     => "",
                "cliente_email_1"                   => "",
                "cliente_email_2"                   => "",
                "fecha_de_emision"                  => @fecha_emision,
                "fecha_de_vencimiento"              => @fecha_vmto ,
                "moneda"                            => @moneda_nube,
                "tipo_de_cambio"                    => "3.919",
                "porcentaje_de_igv"                 => "18.00",
                "descuento_global"                  => "",
                "total_descuento"                   => "",
                "total_anticipo"                    => "",
                "total_gravada"                     => @factura.subtotal ,
                "total_inafecta"                    => "",
                "total_exonerada"                   => "",
                "total_igv"                         => @factura.tax ,
                "total_gratuita"                    => "",
                "total_otros_cargos"                => "",
                "total"                             => @factura.total ,
                "percepcion_tipo"                   => "",
                "percepcion_base_imponible"         => "",
                "total_percepcion"                  => "",
                "total_incluido_percepcion"         => "",
                "detraccion"                        => "true",
                "observaciones"                     =>  @texto_cuentas, 
                "documento_que_se_modifica_tipo"    => "1",
                "documento_que_se_modifica_serie"   => @documento_serie_a_modificar,
                "documento_que_se_modifica_numero"  => @documento_numero_a_modificar,
                "tipo_de_nota_de_credito"           => @tipo_nota_credito,
                "tipo_de_nota_de_debito"            => "",
                "enviar_automaticamente_a_la_sunat" => "true",
                "enviar_automaticamente_al_cliente" => "false",
                "codigo_unico"                      => "",
                "condiciones_de_pago"               => @forma_pago,
                "medio_de_pago"                     => @medio_pago,
                "placa_vehiculo"                    => "" ,
                "orden_compra_servicio"             => "",
                "tabla_personalizada_codigo"        => "",
                "formato_de_pdf"                    => "",
                "detraccion_tipo"                  => @detraccion_tipo,
                "detraccion_total"                 => @detraccion_total,
                "detraccion_porcentaje"            => @detraccion_porcentaje,
                "medio_de_pago_detraccion"         => @medio_de_pago_detraccion,
                "ubigeo_origen"                    => "150101",
                "direccion_origen"                 => "CARR. A VENTANILLA KM 25 PROV.CONT.CALLAO - VENTANILLA",
                "ubigeo_destino"                   => "150134",
                "direccion_destino"                =>  @factura.texto1,
                 "detalle_viaje"  => "Transporte de Combustible",
                 "val_ref_serv_trans"  => "1.00",
                 "val_ref_carga_efec"  => "1.00",
                 "val_ref_carga_util"  => "1.00"
               
            })

          else 

              if @factura.retencion_importe > 0.0



                ln_retencion_tipo = "1"
                ln_total_retencion = @factura.retencion_importe
                ln_retencion_base_imponible = @factura.total 

              else
                ln_retencion_tipo = ""
                ln_total_retencion = ""
                ln_retencion_base_imponible = ""

              end  

            puts " sin detraccion**"


              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "3",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                  "cliente_tipo_de_documento"         => "6",
                  "cliente_numero_de_documento"       => @factura.customer.ruc ,
                  "cliente_denominacion"              => @factura.customer.name ,
                  "cliente_direccion"                 => @factura.customer.direccion_all ,
                  "cliente_email"                     => "percywoeds@gmail.com",
                  "cliente_email_1"                   => "",
                  "cliente_email_2"                   => "",
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => @fecha_vmto ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.919",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => @factura.subtotal ,
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => @factura.tax ,
                  "total_gratuita"                    => "",
                  "total_otros_cargos"                => "",
                  "total"                             => @factura.total ,
                  "percepcion_tipo"                   => "",
                  "percepcion_base_imponible"         => "",
                  "total_percepcion"                  => "",
                  "total_incluido_percepcion"         => "",
                  "detraccion"                        => "false",
                  "observaciones"                     =>  @texto_cuentas, 
                  "documento_que_se_modifica_tipo"    => "1",
                  "documento_que_se_modifica_serie"   => @documento_serie_a_modificar,
                  "documento_que_se_modifica_numero"  => @documento_numero_a_modificar,
                  "tipo_de_nota_de_credito"           => @tipo_nota_credito,
                  "tipo_de_nota_de_debito"            => "",
                  "enviar_automaticamente_a_la_sunat" => "true",
                  "enviar_automaticamente_al_cliente" => "false",
                  "codigo_unico"                      => "",
                  "condiciones_de_pago"               => @forma_pago,
                  "medio_de_pago"                     => @medio_pago,
                  "placa_vehiculo"                    => "" ,
                  "orden_compra_servicio"             => "",
                  "tabla_personalizada_codigo"        => "",
                  "formato_de_pdf"                    => "",
                   "detraccion_tipo"                  => "",
                   "detraccion_total"                 => "",
                   "medio_de_pago_detraccion"         => ""
                  
                 
              })

    end    


# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


         cantidad = 0


        @factura_detail = FacturaDetail.select(:product_id,"SUM(quantity) as quantity","SUM(total) as total").where(factura_id: self.id).group(:product_id)
      
      


          for item_factura in @factura_detail 
              

          puts "*+++++++++++++++++++++"
          puts item_factura.quantity  


                 
                    @valor_unitario = (item_factura.total / item_factura.quantity ) / 1.18 
                    invoice.add_item({
                      codigo: item_factura.product.code ,
                     unidad_de_medida: item_factura.product.unidad.descrip2, 
                    descripcion: item_factura.product.name ,
                    cantidad: item_factura.quantity,
                    valor_unitario:  @valor_unitario  ,
                    tipo_de_igv: 1 

                    })
                  

          end 

          if @factura.payment.day > 0 


                    invoice.add_cuota({
                      cuota: "1" ,
                      fecha_de_pago: @factura.fecha2.strftime("%d-%m-%Y"), 
                      importe: @factura.total * -1 

                    })

          end 




          puts JSON.pretty_generate(invoice )

          result = invoice.deliver

          if result['errors'] 
              puts  "#{result['codigo']}: #{result['errors']}  aviso"
              self.msgerror = "#{result['codigo']}: #{result['errors']}  aviso"
            else 
              self.msgerror = "Nota Credito en nubefact."

          end

          self.processed="1"
     
          self.date_processed = Time.now
          self.save
end 

#####################################################################################################

  

############################process4###############################################################

# Process the invoice
  def process4
       

          Factura.where(id: self.id).update_all("fecha_cuota1 = fecha2, importe_cuota1 =  total - detraccion_importe ")
             @factura = Factura.find(self.id)

          puts @factura.code 

          @fecha_emision = @factura.fecha.strftime("%Y-%m-%d")
          @fecha_vmto    = @factura.fecha2.strftime("%Y-%m-%d")


          if @factura.payment.day == 0 
            @forma_pago = "CONTADO" 
            @medio_pago = "CONTADO"
          else 
             @forma_pago = "CREDITO"
             @medio_pago = "VENTA AL CREDITO"
          end



          ff = @factura.code.split("-")

          @serie  =  ff[0]
          @numero =  ff[1]

            @nc = @factura.documento2.split("-")

           @documento_serie_a_modificar  = @nc[0]
           @documento_numero_a_modificar = @nc[1]

           @tipo_nota_debito = @factura.anexo8.code_nube


          if @factura.moneda_id == 1 
                @moneda_nube = 2
          else
                @moneda_nube = 1
          end
         
          @texto_obs = @factura.guia + " " + @factura.description 

        

          if @factura.detraccion_importe  > 0.0
            puts " ** detraccion********************************************"
              @detraccion_tipo  =  "25"
              @detraccion_total =  @factura.detraccion_importe
              @medio_de_pago_detraccion = "1" 
              @detraccion_porcentaje = @factura.detraccion_percent

            # create a new Invoice object
            invoice = NubeFact::Invoice.new({
                "operacion"                   => "generar_comprobante",
                "tipo_de_comprobante"               => "4",
                "serie"                             =>  @serie,
                "numero"                            =>  @numero ,
                "sunat_transaction"                 => "33",
                "cliente_tipo_de_documento"         => "6",
                "cliente_numero_de_documento"       => @factura.customer.ruc ,
                "cliente_denominacion"              => @factura.customer.name ,
                "cliente_direccion"                 => @factura.customer.direccion_all ,
                "cliente_email"                     => @factura.customer.email ,
                "cliente_email_1"                   => "envio.facturas@valuemi.com.pe",
                "cliente_email_2"                   => @factura.customer.email2,
                "fecha_de_emision"                  => @fecha_emision,
                "fecha_de_vencimiento"              => @fecha_vmto ,
                "moneda"                            => @moneda_nube,
                "tipo_de_cambio"                    => "",
                "porcentaje_de_igv"                 => "18.00",
                "descuento_global"                  => "",
                "total_descuento"                   => "",
                "total_anticipo"                    => "",
                "total_gravada"                     => @factura.subtotal,
                "total_inafecta"                    => "",
                "total_exonerada"                   => "",
                "total_igv"                         => @factura.tax,
                "total_gratuita"                    => "",
                "total_otros_cargos"                => "",
                "total"                             => @factura.total,
                "percepcion_tipo"                   => "",
                "percepcion_base_imponible"         => "",
                "total_percepcion"                  => "",
                "total_incluido_percepcion"         => "",
                "detraccion"                        => "true",
                "observaciones"                     => @texto_obs, 
                "documento_que_se_modifica_tipo"    => "1",
                "documento_que_se_modifica_serie"   => @documento_serie_a_modificar,
                "documento_que_se_modifica_numero"  => @documento_numero_a_modificar,
                "tipo_de_nota_de_credito"           => "",
                "tipo_de_nota_de_debito"            => @tipo_nota_debito,
                "enviar_automaticamente_a_la_sunat" => "true",
                "enviar_automaticamente_al_cliente" => "true",
                "codigo_unico"                      => "",
                "condiciones_de_pago"               => @forma_pago,
                "medio_de_pago"                     => @medio_pago,
                "placa_vehiculo"                    => "",
                "orden_compra_servicio"             => "",
                "tabla_personalizada_codigo"        => "",
                "formato_de_pdf"                    => "",
                "detraccion_tipo"                  => @detraccion_tipo,
                "detraccion_total"                 => @detraccion_total,
                "detraccion_porcentaje"            => @detraccion_porcentaje,
                "medio_de_pago_detraccion"         => @medio_de_pago_detraccion,
                "ubigeo_origen"                    => "150101",
                "direccion_origen"                 => "CARR. A VENTANILLA KM 25 PROV.CONT.CALLAO - VENTANILLA",
                "ubigeo_destino"                   => "150134",
                "direccion_destino"                =>  @factura.texto1,
                 "detalle_viaje"  => "Transporte de Combustible",
                 "val_ref_serv_trans"  => "1.00",
                 "val_ref_carga_efec"  => "1.00",
                 "val_ref_carga_util"  => "1.00"
               
            })

          else 

            puts " sin detraccion**"
              # create a new Invoice object
              invoice = NubeFact::Invoice.new({
                  "operacion"                   => "generar_comprobante",
                  "tipo_de_comprobante"               => "4",
                  "serie"                             =>  @serie,
                  "numero"                            =>  @numero ,
                  "sunat_transaction"                 => "1",
                  "cliente_tipo_de_documento"         => "6",
                  "cliente_numero_de_documento"       => @factura.customer.ruc ,
                  "cliente_denominacion"              => @factura.customer.name ,
                  "cliente_direccion"                 => @factura.customer.direccion_all ,
                  "cliente_email"                     => @factura.customer.email ,
                  "cliente_email_1"                   => "envio.facturas@valuemi.com.pe",
                  "cliente_email_2"                   => @factura.customer.email2,
                  "fecha_de_emision"                  => @fecha_emision,
                  "fecha_de_vencimiento"              => @fecha_vmto ,
                  "moneda"                            => @moneda_nube,
                  "tipo_de_cambio"                    => "3.712",
                  "porcentaje_de_igv"                 => "18.00",
                  "descuento_global"                  => "",
                  "total_descuento"                   => "",
                  "total_anticipo"                    => "",
                  "total_gravada"                     => @factura.subtotal,
                  "total_inafecta"                    => "",
                  "total_exonerada"                   => "",
                  "total_igv"                         => @factura.tax,
                  "total_gratuita"                    => "",
                  "total_otros_cargos"                => "",
                  "total"                             => @factura.total,
                  "percepcion_tipo"                   => "",
                  "percepcion_base_imponible"         => "",
                  "total_percepcion"                  => "",
                  "total_incluido_percepcion"         => "",
                  "detraccion"                        => "false",
                  "observaciones"                     => @texto_obs, 
                   "documento_que_se_modifica_tipo"    => "1",
                  "documento_que_se_modifica_serie"   => @documento_serie_a_modificar,
                  "documento_que_se_modifica_numero"  => @documento_numero_a_modificar,
                  "tipo_de_nota_de_credito"           => "",
                  "tipo_de_nota_de_debito"            => @tipo_nota_debito,
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




          end    


# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0


         @factura_detail = FacturaDetail.select(:product_id,"SUM(quantity) as quantity","SUM(total) as total").where(factura_id: self.id).group(:product_id)
      
     

for item_factura in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts item_factura.quantity  
#puts item_factura.preciosigv 

        if @factura.servicio == "true"
          invoice.add_item({
            codigo: item_factura.product.code ,
         unidad_de_medida: item_factura.product.unidad.descrip2, 
          descripcion: item_factura.product.name ,
          cantidad: item_factura.quantity,
          valor_unitario: item_factura.preciosigv.round(3)   ,
          tipo_de_igv: 1 

          })
        else 

          @valor_unitario = (item_factura.total / item_factura.quantity ) / 1.18 
          invoice.add_item({
            codigo: item_factura.product.code ,
           unidad_de_medida: item_factura.product.unidad.descrip2, 
          descripcion: item_factura.product.name ,
          cantidad: item_factura.quantity,
          valor_unitario:  @valor_unitario  ,
          tipo_de_igv: 1 

          })

        end 

end 

if @factura.importe_cuota1 > 0.00
          invoice.add_cuota({
            cuota: "1" ,
            fecha_de_pago: @factura.fecha_cuota1.strftime("%d-%m-%Y"), 
            importe: @factura.importe_cuota1 

          })

end 

if @factura.importe_cuota2 > 0.00
          invoice.add_cuota({
             cuota: "2" , 
             fecha_de_pago: @factura.fecha_cuota2.strftime("%d-%m-%Y"), 
             importe: @factura.importe_cuota2 


          })

end 
if @factura.importe_cuota3 > 0.00 
          invoice.add_cuota({
             cuota: "3" ,
            fecha_de_pago: @factura.fecha_cuota3.strftime("%d-%m-%Y"), 
            importe: @factura.importe_cuota3 ,

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


############################fimn process4######################################################################

  def cerrar
    if(self.processed == "3" )         
      
      self.processed="3"
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Process the invoice
  def anular
    
    if(self.processed == "2" )          
      self.processed="2"
      self.subtotal =0
      self.tax = 0
      self.total = 0
      self.balance = 0
      
      self.date_processed = Time.now
      self.save


          ff = self.code.split("-")

          case  self.document_id 

          when  1

                @serie  =   ff[0]
          when  2

                 @serie = ff[0]
          when  12

                 @serie = ff[0]

          when  13

                @serie  = ff[0]
          end 

          @numero =  ff[1]
       

       # create a new Invoice object
          invoice = NubeFact::Invoice.anular(@serie,@numero ,"ERROR EN EMISION ")

          puts JSON.pretty_generate(invoice )

          



    end
  end

  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
  
  def get_importe_soles1
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.subtotal*-1
                    
          else  
                  valor = self.subtotal 
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles2
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.tax*-1
                    
          else  
                  valor = self.tax 
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.total*-1
                    
          else  
                  valor = self.total 
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_dolares
       valor = 0
       if self.moneda_id ==1
          if self.document_id   == 2
                  valor = self.balance*-1
                    
          else  
                  valor = self.balance
          
           end   
          end 
        return valor         
  end
  
  def get_importe_soles_balance
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.balance*-1
                    
          else  
                  valor = self.balance 
          
           end   
            
    end
    return valor     
  end 
  
    
  def get_ventas_market(fecha)
    
      fecha0 =  fecha.to_date
      puts "fecha market"
      puts fecha0
      
     facturas = Factura.where(["fecha >= ? and fecha <= ?   " , "#{fecha0} 00:00:00","#{fecha0} 23:59:59" ])
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
 def get_ventas_market_tarjeta(fecha)
   
     fecha0= fecha.to_date  
     facturas = Factura.where(["fecha >= ? and fecha <= ?  and tarjeta_id <> 1 " , "#{fecha0} 00:00:00","#{fecha0} 23:59:59" ])
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
     fecha0 = fecha.to_date 
     facturas = Factura.where(["fecha >= ? and fecha <= ?   " , "#{fecha0} 00:00:00","#{fecha0} 23:59:59" ])
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
 
 def get_tipoventa(id)
    
    a= Tipoventum.find(id)
    
    if a
      return a.nombre
    else
      return "-"
    end 
 end 
 
 
 def get_galones
     ret = 0
     a= FacturaDetail.where(factura_id: self.id)
     
          for   detalle    in a
          
              ret += detalle.quantity
          end 
     
    return ret 
   
 end  
 
 def get_nombretarjeta(id)
    a = Tarjetum.find(id)
    if a == nil
        return "No existe"
    else
      return a.nombre
    end 
 end 
       
  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Factura.create! row.to_hash 
        end
    end     

    def self.import2(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          FacturaDetail.create! row.to_hash 
        end
      end      
    
   
   def get_empleado_nombre(id) 
      a= Employee.find(id)
      
      if a
          return a.full_name
      else
         return "Codigo No registrado "
      end 
     
   end  


  def get_dias(id)

       a  =  Payment.find(id)

       return a.day 

  end 



  def get_estado_nubefact

    if !self.msgerror.nil?

      return self.msgerror 
    else 
      return "-"  
    end 
      
  end 

  def get_producto
  
    if FacturaDetail.where(factura_id: self.id ).exists?

       a = FacturaDetail.where(factura_id: self.id )
     return   a.first.product.name2
    else
     return ""
    end 
  end   
  
  def get_precio 
  
    if FacturaDetail.where(factura_id: self.id ).exists?

       a = FacturaDetail.where(factura_id: self.id )
     return   a.first.price 
    else
     return 0.0
    end 
  end  


  def get_tipocambio(fecha1)

      
      fecha0 = fecha1.to_date 



      @tipocambio = Tipocambio.where("dia>=? and dia<=?","#{fecha0} 00:00:00","#{fecha0} 23:59:59")


      if @tipocambio.last != nil  
        return @tipocambio.last.venta
      else
        return 0.00
      end 
   end 

  
end