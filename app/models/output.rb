class Output < ActiveRecord::Base


  self.per_page = 20

  validates_presence_of :company_id, :supplier_id, :employee_id,:truck_id,:code, :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier
  belongs_to :employee
  belongs_to :truck 
  belongs_to :user
  belongs_to :payment 
  
  has_many :output_details
  
  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
                
        total = price.to_f * quantity.to_i
                
        begin
          product = Product.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_tax(items)
    tax = 0
    
    
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            price = parts[2]        
        
            total = price.to_f * quantity.to_i            
        
            begin
              product = Product.find(id.to_i)
              
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
    
    return tax
  end
  
  def delete_products()
    invoice_products = InvoiceProduct.where(invoice_id: self.id)
    
    for ip in invoice_products
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
        
        total = price.to_f * quantity.to_i        
        
        begin
          product = Product.find(id.to_i)
          
          new_invoice_product = InvoiceProduct.new(:invoice_id => self.id, :product_id => product.id, :price => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f, :total => total.to_f)
          new_invoice_product.save

        rescue
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code}"
  end
  def get_products    
    @itemproducts = InvoiceProduct.find_by_sql(['Select invoice_products.price,invoice_products.quantity,invoice_products.discount,invoice_products.total,products.name  from invoice_products INNER JOIN products ON invoice_products.product_id = products.id where invoice_products.invoice_id = ?', self.id ])
    puts self.id

    return @itemproducts
  end
  
  def get_invoice_products
    invoice_products = InvoiceProduct.where(invoice_id:  self.id)    
    return invoice_products
  end
  
  def products_lines
    products = []
    invoice_products = InvoiceProduct.where(invoice_id:  self.id)
    
    invoice_products.each do | ip |

      ip.product[:price] = ip.price
      ip.product[:quantity] = ip.quantity      
      ip.product[:total] = ip.total
      #products.push("#{ip.product.id}|BRK|#{ip.product.curr_quantity}|BRK|#{ip.product.curr_price}|BRK|#{ip.product.curr_discount}")
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}|BRK|#{ip.product.price}")
    end


    return products.join(",")
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
      return "Si"
    elsif (self.processed == "3")
       return "Si"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Si"
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

def correlativo
        
        numero = Voided.find(12).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'12').update_all(:numero =>lcnumero)        
  end

end
