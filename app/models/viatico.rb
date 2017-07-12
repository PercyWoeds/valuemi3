class Viatico < ActiveRecord::Base
    
    
self.per_page = 20


  validates_presence_of :company_id,  :code, :user_id,:inicial,:fecha1

  validates_uniqueness_of :code
  
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  
  belongs_to :user
  

  has_many   :viatico_details
  
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
                     "Fecha",
                     "Cliente",
                     "Moneda",
                     "SUBTOTAL",
                     "IGV.",
                     "TOTAL",
                     "ESTADO"]
  TABLE_HEADERS3 = ["TD",
                      "Documento",
                     "Fecha",
                     "Fec.Vmto",
                     "Cliente",
                     "Moneda",                                         
                     "SOLES",
                     "DOLARES ",
                     "DETRACCION",
                     "OBSERV"]
  

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end



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

def get_total_inicial(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
         quantity = parts[1]
         tm  = parts[3]
         inicial  = parts[4]
         
        
            total =  inicial.to_f
         
        begin
          subtotal = total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_total_ing(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
          
        
        id = parts[0]
        quantity = parts[1]
        tm  = parts[3].to_i
        
          if tm == 6 || tm == 10
            total = quantity.to_f
          else
            total = 0
          end 
        
        begin
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_total_sal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
         tm  = parts[3]
         if tm == 6 || tm == 10
            total = 0
          else
            total =  quantity.to_f
            
          end 
        
        begin
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  
  def delete_products()
    invoice_services = InvoiceService.where(factura_id: self.id)
    
    for ip in invoice_services
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id       = parts[0]
        quantity = parts[1]
        detalle1 = parts[2]
        tm1      = parts[3]
        detalle2 = parts[5]
        total    =  quantity.to_f
        
    
          product = Tranportorder.find(id.to_i)
          
          new_invoice_product = ViaticoDetail.new(:viatico_id => self.id,:descrip=> detalle2,:importe=> total ,:detalle=> detalle1,:tm=>tm1,:tranportorder_id=> product.id)

          new_invoice_product.save

      
          
    
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

  def identifier
    return "#{self.code} "
  end
  def get_viaticos
      @viaticos = ViaticoDetail.where(:viatico_id=> self.id)
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


  
  def get_invoices_details

  
    
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
  # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.zone.now
      self.save
    end
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
 
  
end
