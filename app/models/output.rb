class Output < ActiveRecord::Base


  self.per_page = 20
  validates_uniqueness_of :code
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



   TABLE_HEADERS2 = ["ITEM",
                      "DOCUMENTO",
                     "FECHA",
                     "CODE",
                     "PRODUCTO",
                     "UNIDAD",                                          
                     "EMPLEADO",
                     "PLACA",
                     "CANTIDAD",
                     "COSTO ",
                     "TOTAL"]

  
  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
                
        total = price.to_f * quantity.to_f
                
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
      
            total = price.to_f * quantity.to_f            
        
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
    invoice_products = OutputDetail.where(invoice_id: self.id)
    
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
        total = price.to_f * quantity.to_f        
        

        begin
          product = Product.find(id.to_i)          
          new_invoice_product = OutputDetail.new(:output_id => self.id, :product_id => product.id, 
          :price => price.to_f, :quantity => quantity.to_f, :total => total.to_f)
          new_invoice_product.save
        end
      end
    end
  end
  
  def identifier
    return "#{self.code}"
  end
  def get_products    
    @itemproducts = OutputDetail.find_by_sql(['Select output_details.price,
      output_details.quantity,output_details.total,
      products.name,products.unidad  
      from output_details INNER JOIN products ON 
      output_details.product_id = products.id 
      where output_details.output_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_invoice_products
    invoice_products = OutputDetail.where(output_id:  self.id)    
    return invoice_products
  end
  
  def products_lines
    products = []
    invoice_products = OutputDetail.where(output_id:  self.id)
    
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
      return "Procesado "

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

      output_details = OutputDetail.where( output_id: self.id)
    
      for ip in output_details

        product = ip.product
      
        if(product.quantity)
          if(self.return == "0")
            ip.product.quantity -= ip.quantity
          else
            ip.product.quantity += ip.quantity
          end
          ip.product.save
        end        
        
        #actualiza stock
         stock_product =  Stock.find_by(:product_id => ip.product_id)

        if stock_product 
           $last_stock = stock_product.quantity - ip.quantity
           stock_product.unitary_cost = ip.price   
           stock_product.quantity = $last_stock

        else
          $last_stock = 0
          stock_product= Stock.new(:store_id=>1,:state=>"Lima",:unitary_cost=> ip.price ,
          :quantity=> ip.quantity,:minimum=>0,:user_id=>@user_id,:product_id=>ip.product_id,
          :document_id=>self.document_id,:documento=>self.documento)           
        end 
        stock_product.save        
        self.date_processed = Time.now
        self.save    
      end
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


  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end



end
