class Factura < ActiveRecord::Base
  self.per_page = 20


  validates_presence_of :company_id, :customer_id, :code, :user_id,:fecha
  validates_uniqueness_of :code
  
  
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
                     

 



  def self.to_csv(result)
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
        tot+= item.quantity
    end 
    
    return tot
    
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


          @factura = Factura.find(self.id)

          puts @factura.code 


    # create a new Invoice object
invoice = NubeFact::Invoice.new({

    "operacion"                   => "generar_comprobante",
    "tipo_de_comprobante"               => "1",
    "serie"                             => "FF01",
    "numero"                    => "395",
    "sunat_transaction"             => "1",
    "cliente_tipo_de_documento"       => "6",
    "cliente_numero_de_documento"     => "20550943060",
    "cliente_denominacion"              => "SCLT PERU SAC",
    "cliente_direccion"                 => "-",
    "cliente_email"                     => "",
    "cliente_email_1"                   => "",
    "cliente_email_2"                   => "",
    "fecha_de_emision"                  => "2020-11-01",
    "fecha_de_vencimiento"              => "",
    "moneda"                            => "1",
    "tipo_de_cambio"                    => "",
    "porcentaje_de_igv"                 => "18.00",
    "descuento_global"                  => "",
    "descuento_global"                  => "",
    "total_descuento"                   => "",
    "total_anticipo"                    => "",
    "total_gravada"                     => @factura.subtotal,
    "total_inafecta"                    => "",
    "total_exonerada"                   => "",
    "total_igv"                         => @factura.tax,
    "total_gratuita"                    => "",
    "total_otros_cargos"                => "",
    "total"                             =>   @factura.total,
    "percepcion_tipo"                   => "",
    "percepcion_base_imponible"         => "",
    "total_percepcion"                  => "",
    "total_incluido_percepcion"         => "",
    "detraccion"                        => "false",
    "observaciones"                     => "",
    "documento_que_se_modifica_tipo"    => "",
    "documento_que_se_modifica_serie"   => "",
    "documento_que_se_modifica_numero"  => "",
    "tipo_de_nota_de_credito"           => "",
    "tipo_de_nota_de_debito"            => "",
    "enviar_automaticamente_a_la_sunat" => "true",
    "enviar_automaticamente_al_cliente" => "false",
    "codigo_unico"                      => "",
    "condiciones_de_pago"               => "",
    "medio_de_pago"                     => "",
    "placa_vehiculo"                    => "",
    "orden_compra_servicio"             => "",
    "tabla_personalizada_codigo"        => "",
    "formato_de_pdf"                    => "",


})

# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.


cantidad = 0

@factura_detail = FacturaDetail.where(factura_id: @factura.id)

for item_factura in @factura_detail 
    

puts "*+++++++++++++++++++++"
puts item_factura.quantity  

  invoice.add_item({
 unidad_de_medida: 'ZZ',
  descripcion: 'Osito de peluche de taiwan',
  cantidad: 1,
  valor_unitario: "#{item_factura.price_discount.round(2)}",
  tipo_de_igv: 1,

                   

  })

end 

result = invoice.deliver



 end




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


  
end