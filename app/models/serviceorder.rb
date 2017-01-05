class Serviceorder < ActiveRecord::Base
  self.per_page = 20

  #autoload :InvoiceLine,                    "invoice_line"

 # property :lines,                           [InvoiceLine]

  validates_presence_of :company_id, :supplier_id, :code, :user_id,:moneda_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier
  belongs_to :user
  belongs_to :payment 
  belongs_to :moneda  
  belongs_to :document
    
  has_many :serviceorder_services
  
 TABLE_HEADERS = ["ITEM",
                     "CANTIDAD",
                     "DESCRIPCION",
                     "PRECIO UNITARIO",
                     "DSCTO",
                     "VALOR TOTAL"]

def not_serviceorders_with?(serviceorder_id)

  purchaseships.where(serviceorder_id: serviceorder_id).count < 1

end


def self.search(param)

  return Serviceorder.none if param.blank?
  param.strip!
  (code_matches(param)) 

end

def self.code_matches(param)

 matches(' code ', param)

end


def self.matches(field_name, param)

where("#{field_name} like ?", "%#{param}%")

end

def correlativo
        
        numero = Voided.find(6).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'6').update_all(:numero =>lcnumero)        
end


#Remove turbolinks from application.js file if having issues with search



  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Servicebuy.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_tax(items, supplier_id)
    tax = 0
    
    supplier = Supplier.find(supplier_id)
    
    if(supplier)
      if(supplier.taxable == "1")
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            price = parts[2]
            discount = parts[3]
        
            total = price.to_f * quantity.to_i
            total -= total * (discount.to_f / 100)
        
            begin
              product = Servicebuy.find(id.to_i)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
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
  
  def delete_services()
    invoice_services = ServiceorderService.where(serviceorder_id: self.id)
    
    for ip in invoice_services
      ip.destroy
    end
  end
  
  def add_services(items)

    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
      

        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Servicebuy.find(id.to_i)          

          new_invoice_product = ServiceorderService.new(:serviceorder_id => self.id, :servicebuy_id => product.id, :price => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f, :total => total.to_f)
          new_invoice_product.save
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.supplier.name}"
  end

  def get_services    
@itemservices = ServiceorderService.find_by_sql(['Select serviceorder_services.price,
serviceorder_services.quantity,serviceorder_services.discount,serviceorder_services.total,
servicebuys.name,servicebuys.id  from serviceorder_services INNER JOIN servicebuys ON
serviceorder_services.servicebuy_id = servicebuys.id where serviceorder_services.serviceorder_id = ?', self.id ])
    puts self.id

    return @itemservices
  end

  def total_pagar
   total_pagar =  self.total - self.detraccion
   return total_pagar
   
  end 
  
  def get_invoice_services
    invoice_services = ServiceorderService.where(serviceorder_id:  self.id)    
    return invoice_services
  end
  
  def services_lines
    services = []
    order_services = ServiceorderService.where(serviceorder_id:  self.id)
    
    order_services.each do | ip |

      ip.servicebuy[:price] = ip.price
      ip.servicebuy[:quantity] = ip.quantity
      ip.servicebuy[:discount] = ip.discount
      ip.servicebuy[:total] = ip.total
      
      services.push("#{ip.servicebuy.id}|BRK|#{ip.servicebuy.quantity}|BRK|#{ip.servicebuy.price}|BRK|#{ip.servicebuy.discount}")

    end 

    return services.join(",")
  end

  
  def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  
    else   
      return "Not yet processed"
        
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
      self.date_processed = Time.now
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
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end

end 

