class Lgv < ActiveRecord::Base
   
    
  self.per_page = 20
  
  validates_presence_of :company_id,  :code, :fecha,:compro_id,:peaje ,:inicial,:peaje 
  validates_uniqueness_of :code
  
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :user
  belongs_to :compro  
  

  has_many   :lgv_details
  
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
          Lgv.create! row.to_hash 
        end
  end      

  def get_vencido

      if(self.fecha2 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

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
         inicial  = parts[6]
         
  
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
        quantity = parts[4]
      
        
            total =  quantity.to_f
         
        
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
        quantity = parts[5]
        
        total =  quantity.to_f
          
        
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
        
    
        id        = parts[0]
        fecha     = parts[1]
        td        = parts[2]
        documento = parts[3]
        importe   = parts[4]
        
        total     =  importe.to_f
        
        
    
          product = Gasto.find(id.to_i)
          
          new_invoice_product = LgvDetail.new(:lgv_id => self.id,:gasto_id=>id,:fecha=> fecha ,:td=> td,:documento=> documento,:total=> total )

          new_invoice_product.save
          
    
     end
    end
  end
  def identifier
    return "#{self.code} "
  end
  def get_lgvs
      @lgvs = LgvDetail.where(:lgv_id=> self.id)
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
 
# modificacion lines
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

