

class PurchaseDetail < ActiveRecord::Base
  
 validates_presence_of :purchase_id, :product_id, :price_with_tax, :quantity, :total,:price_without_tax
  
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


def get_products    
    
    
      @itemproducts = PurchaseDetail.find_by_sql(['Select purchase_details.price_with_tax as price,purchase_details.quantity,
      purchase_details.discount,purchase_details.price_without_tax as price2,purchase_details.total,
      servicebuys.name  from purchase_details INNER JOIN servicebuys ON 
      purchase_details.product_id = servicebuys.id where purchase_details.purchase_id = ?', self.id ])
    
    

    return @itemproducts
  end

end
