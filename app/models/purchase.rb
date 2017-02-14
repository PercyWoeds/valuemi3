class Purchase < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :supplier_id, :documento,:document_id,:date1,:date2,:date3
        
    
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier 
  belongs_to :user  
  belongs_to :document
  belongs_to :moneda
  belongs_to :payment

  has_many :purchase_details



TABLE_HEADERS2  = ["ITEM ",
                      "DOCUMENTO",
                     "FECHA",
                     "CODIGO",
                     "PRODUCTO",
                     "UNIDAD",
                     "PROVEEDOR",
                     " ",
                     " ",
                     "CANTIDAD",
                     "COSTO",
                     "TOTAL "]




  def get_vencido

      if(self.date3 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

  end 


  def not_purchase_with?()
    document_tipo = self.document_id
    document_numero=  self.documento
    
    existe=Purchase.where(document_id: document_tipo,documento: document_numero).count < 1
    return existe 
  end

  def get_subtotal2(items)
    subtotal = 0

    for item in items
                    
        total = item.price * item.quantity
        total -= total * (item.discount / 100)        
        begin        
          subtotal += total      
        end     
    end  
    return subtotal
  end 

  def get_tax2(items, supplier_id)
    tax = 0
    
    supplier = Supplier.find(supplier_id)
    
    if(supplier)
      if(supplier.taxable == "1")
        for item in items
          if(item and item != "")

            total = item.price * item.quantity
            total -= total * (item.discount / 100)
        
            begin
              product = Product.find(item.product_id)
              
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

  
  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        price2 = parts[4]
        
        total = price.to_f * quantity.to_i
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
      end
    end
    
    return tax
  end
  
  def delete_products()
    purchase_details = PurchaseDetail.where(purchase_id: self.id)
    
    for ip in purchase_details
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
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          
          new_pur_product = PurchaseDetail.new(:purchase_id => self.id, :product_id => product.id,
          :price_with_tax => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f,
          :total => total.to_f)
          new_pur_product.save
        rescue
        end

                


      end
    end
  end   

  def add_products2(items)
    for item in items
        
        total = item.price * item.quantity
        total -= total * (item.discount / 100)
        lcprice_tax = item.price*1.18      
        

        product = Product.find(item.product_id)
  
        new_pur_product = PurchaseDetail.new(:purchase_id => self.id, :product_id => product.id,
            :price_with_tax => lcprice_tax,:price_without_tax=>item.price, :quantity => item.quantity, 
            :discount => item.discount, :total => item.total )
        new_pur_product.save   

          
      
    end

  end   

  
  
  def identifier
    return "#{self.documento} - #{self.supplier.name}"
  end
  
  def get_products    
    @itemproducts = PurchaseDetail.find_by_sql(['Select purchase_details.price_with_tax as price,purchase_details.quantity,
      purchase_details.discount,purchase_details.price_without_tax as price2,purchase_details.total,
      products.name  from purchase_details INNER JOIN products ON 
      purchase_details.product_id = products.id where purchase_details.purchase_id = ?', self.id ])
    puts self.id

    return @itemproducts
  end
  
  def get_purchase_details
    purchase_details = PurchaseDetail.where(purchase_id:  self.id)    
    return purchase_details
  end
  
  def products_lines
    products = []
    purchase_details = PurchaseDetail.where(purchase_id:  self.id)   
    purchase_details.each do | ip |

      ip.product[:price] = ip.price_with_tax
      ip.product[:quantity] = ip.quantity
      ip.product[:discount] = ip.discount
      ip.product[:price2] = ip.price_without_tax
      ip.product[:total] = ip.total
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}|BRK|#{ip.product.price}|BRK|#{ip.product.discount}|BRK|#{ip.product.price2}|BRK|#{ip.product.total}")
      end

    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Procesado"
    else
      return "No Procesado"
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Si"
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
  
  # Process the purchase
  def process

    if(self.processed == "1" or self.processed == true)

      purchase_details =PurchaseDetail.where(purchase_id: self.id)
    
      for ip in purchase_details

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
           $last_stock = stock_product.quantity + ip.quantity
           stock_product.unitary_cost = ip.price_without_tax   
           stock_product.quantity = $last_stock

        else
          $last_stock = 0
          stock_product= Stock.new(:store_id=>1,:state=>"Lima",:unitary_cost=> ip.price_without_tax,
          :quantity=> ip.quantity,:minimum=>0,:user_id=>@user_id,:product_id=>ip.product_id,
          :document_id=>self.document_id,:documento=>self.documento)           
        end 

        stock_product.save

        self.date_processed = Time.now
        self.save
      

      end
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
