class Ajust < ActiveRecord::Base
 self.per_page = 20
  
  validates_presence_of :company_id, :user_id,:fecha1 
 
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :user
  
  
  has_many :ajust_details


  TABLE_HEADERS = ["ITEM",
                     "CANTIDAD",
                     "CODIGO",
                     "DESCRIPCION",
                     "PRECIO UNITARIO",
                     "DSCTO",
                     "VALOR TOTAL"]

  TABLE_HEADERS1 = ["ITEM",
                     "PROVEEDOR",
                     "ORDEN",
                     "FECHA",
                     "CANT.",
                     "CODIGO",
                     "DESCRIPCION",
                     "PRE.COSTO",
                     "DSCTO.",
                     "TOTAL" ]

 TABLE_HEADERS2 = ["ITEM",
                     "ORDEN",
                     "FECHA1",
                     "FECHA2",
                     "PROVEEDOR",
                     "MONEDA ",
                     "S/.",
                     "USD",                     
                     "TOTAL" ]

    

  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
  
        total =  quantity.to_f
     
        
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
          
        
            total =  quantity.to_f
           
        
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
    ajust_details = AjustDetail.where(ajust_id: self.id)
    
    for ip in ajust_details
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
       
        total =  quantity.to_f
       

        begin
          product = Product.find(id.to_i)          
          new_ajust_detail = AjustDetail.new(:ajust_id => self.id, :product_id => product.id, :quantity => quantity.to_f)
          new_ajust_detail.save
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.supplier.name}"
  end
  
  def get_products    
    @itemproducts = AjustDetail.find_by_sql(['Select ajust_details.quantity,
      products.name,products.id,products.code
    	from ajust_details INNER JOIN products ON ajust_details.product_id = products.id
    	where ajust_details.ajust_id = ?', self.id ])
    puts self.id

    return @itemproducts
  end
  def get_products2
    @itemproducts = AjustDetail.find_by_sql(['Select ajust_details.id,ajust_details.product_id,ajust_details.quantity_transit as qty,
      ajust_details.quantity,
      ajust_details.pending,
      ajust_details.discount,ajust_details.total,
      products.name 
      from ajust_details
      INNER JOIN products ON ajust_details.product_id = products.id
      where ajust_details.ajust_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_ajust_details
    ajust_details = AjustDetail.where(ajust_id:  self.id)    
    return ajust_details
  end
  
  def products_lines
    products = []
    ajust_details = AjustDetail.where(ajust_id:  self.id)
    
    ajust_details.each do | ip |
      ip.product[:price] = ip.price
    
      ip.product[:CurrTotal] = ip.total      
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}")
    end

    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Procesado"
    elsif (self.processed == "3")
      return "Cerrado"
    else
      return "No procesado"
    end
  end
  
  def get_processed_short
    if(self.processed == "1" || self.processed == "3")
      return "Si"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1" )
      return "Yes"
    else
      return "No"
    end
  end
  # Process the ajust
  def process

    if(self.processed == "1" or self.processed == true)
      self.processed="1"      
      self.date_processed = Time.now
      self.save
    end
  end
  def process_cerrar

    if(self.processed == "3" or self.processed == true)
      self.processed="3"      
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
