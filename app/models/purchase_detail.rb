

class PurchaseDetail < ActiveRecord::Base
  
 validates_presence_of :purchase_id, :product_id, :price_with_tax, :quantity, :total,
 :price_without_tax,:grifo ,:mayorista 
  
  belongs_to :purchase	
  belongs_to :product


  def get_subtotal(items)
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

  def get_tax(items, supplier_id)
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


  def get_service(id) 
    
    
      @itemproducts =  Servicebuy.find(id)
    

    return @itemproducts
  end

  def calcular_saldo

    self.grifo = 0

    if !self.qty1.nil?
       self.grifo += self.qty1 
    end 
 if !self.qty2.nil?
       self.grifo += self.qty2 
    end 
 if !self.qty3.nil?
       self.grifo += self.qty3 
    end 
 if !self.qty4.nil?
       self.grifo += self.qty4 
    end 
 if !self.qty5.nil?
       self.grifo += self.qty5 
    end 
 if !self.qty6.nil?
       self.grifo += self.qty6 
    end 
 if !self.qty7.nil?
       self.grifo += self.qty7 
    end 
 if !self.qty8.nil?
       self.grifo += self.qty8 
    end 
 if !self.qty9.nil?
       self.grifo += self.qty9 
    end 
 if !self.qty10.nil?
       self.grifo += self.qty10 
    end 


  end 


end
