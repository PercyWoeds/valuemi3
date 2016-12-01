class Inventory < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id , :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :category 
  belongs_to :user
  
  has_many :inventory_details

  def self.AddCategory(params)        
    
    @category1 = ProductsCategory.where('category = ? ', "#{AddCategory}") if params[:AddCategory].present?
      
    Product.where(:category => @category1.id, :status => 'Available').each do |item|
      @inventorydetails = InventoryDetail.new(:inventory_id=> self.id ,:product_id=> item.product_id,:logicalStock=> item.quantity,:physicalStock => 0,:cost => item.cost ,:price =>item.price)
      @inventorydetails.save 
    end

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
        
        totallogical = cost.to_f * logicalStock.to_i
        #total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          subtotal += totallogical
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  
  def delete_products()
    inventory_details = InventoryDetails.where(inventory_id: self.id)
    
    for ip in invoice_details
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
          
          new_inventory_details = InventoryDetails.new(:invoice_id => self.id, :product_id => product.id, :price => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f, :total => total.to_f)
          new_inventory_details.save
        rescue
        end
      end
    end
  end
  
  def identifier
    return "#{self.id} - #{self.category}"
  end
  def get_products    
    
    @itemproducts = InventoryDetail.find_by_sql(['Select inventory_details.product_id,inventory_details.logicalStock,inventory_details.physicalStock,inventory_details.cost,inventory_details.price,inventory_details.totallogical,inventory_details.totalphysical,products.name  from inventory_details INNER JOIN products ON inventory_details.product_id = products.id where inventory_details.inventory_id = ?', self.id ])


    return @itemproducts
  end
  
  def get_inventory_products
    inventory_products = InventoryDetails.where(inventory_id:  self.id)    
    return inventory_products
  end
  
  def products_lines
    products = []
    inventory_products = InventoryDetails.where(inventory_id:  self.id)
    
    inventory_products.each do | ip |

      ip.product[:price] = ip.price
      ip.product[:quantity] = ip.quantity
      ip.product[:discount] = ip.discount
      ip.product[:total] = ip.total
      #products.push("#{ip.product.id}|BRK|#{ip.product.curr_quantity}|BRK|#{ip.product.curr_price}|BRK|#{ip.product.curr_discount}")
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
  
  # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)
      inventory_products = InventoryDetails.where(inventory_id: self.id)
    
      for ip in inventory_products
        product = ip.product
        
        if(product.quantity)
          if(self.return == "0")
            ip.product.quantity -= ip.quantity
          else
            ip.product.quantity += ip.quantity
          end
          ip.product.save
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
