class Purchaseorder < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :supplier_id, :code, :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier
  belongs_to :user
  belongs_to :payment 
  belongs_to :moneda  
  belongs_to :document
  
  
  has_many :purchaseorder_details


  TABLE_HEADERS = ["ITEM",
                     "CANTIDAD",
                     "DESCRIPCION",
                     "PRECIO UNITARIO",
                     "DSCTO",
                     "VALOR TOTAL"]




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
    puts "get tax "
    
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

              puts "codigo"
              puts id 

              if(product)

                puts product.tax1.to_s
                

                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
                end
              else 
                puts "producto no "
                puts id.to_s

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
    purchaseorder_details = PurchaseorderDetail.where(purchaseorder_id: self.id)
    
    for ip in purchaseorder_details
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

        puts parts
          

        begin
          product = Product.find(id.to_i)          
          new_purchaseorder_detail = PurchaseorderDetail.new(:purchaseorder_id => self.id, :product_id => product.id, :price => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f, :total => total.to_f)
          new_purchaseorder_detail.save
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.supplier.name}"
  end
  
  def get_products    
    @itemproducts = PurchaseorderDetail.find_by_sql(['Select purchaseorder_details.price,
    	purchaseorder_details.quantity,purchaseorder_details.discount,purchaseorder_details.total,
      products.name 
    	from purchaseorder_details INNER JOIN products ON purchaseorder_details.product_id = products.id
    	where purchaseorder_details.purchaseorder_id = ?', self.id ])
    puts self.id

    return @itemproducts
  end
  def get_products2
    @itemproducts = PurchaseorderDetail.find_by_sql(['Select purchaseorder_details.id,purchaseorder_details.product_id,purchaseorder_details.quantity_transit as qty,
      purchaseorder_details.quantity,
      purchaseorder_details.pending,
      purchaseorder_details.discount,purchaseorder_details.total,
      products.name 
      from purchaseorder_details
      INNER JOIN products ON purchaseorder_details.product_id = products.id
      where purchaseorder_details.purchaseorder_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_purchaseorder_details
    purchaseorder_details = PurchaseorderDetail.where(purchaseorder_id:  self.id)    
    return purchaseorder_details
  end
  
  def products_lines
    products = []
    purchaseorder_details = PurchaseorderDetail.where(purchaseorder_id:  self.id)
    
    purchaseorder_details.each do | ip |
      ip.product[:price] = ip.price
      ip.product[:quantity] = ip.quantity
      ip.product[:discount] = ip.discount
      ip.product[:CurrTotal] = ip.total      
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}|BRK|#{ip.product.price}|BRK|#{ip.product.discount}")
    end

    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Processed"
    else
      return "Not yet processed"
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
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
  # Process the purchaseorder
  def process

    if(self.processed == "1" or self.processed == true)
      purchaseorder_details = PurchaseorderDetail.where(purchaseorder_id: self.id)
    
      for ip in purchaseorder_details
        product = ip.product
        
        if(ip.quantity)    
          if(self.return == "1")
            ip.product.quantity_transit -= ip.quantity
          else
            ip.product.quantity_transit += ip.quantity
          end
          ip.product.save
        else
         puts  product.quantity
        end
      end
      
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
