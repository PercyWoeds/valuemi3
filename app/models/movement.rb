class Movement < ActiveRecord::Base

self.per_page = 20
  
  validates_presence_of :company_id, :supplier_id, :code, :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier
  belongs_to :user
  belongs_to :truck 
  belongs_to :employee
  belongs_to :subcontrat
  belongs_to :address
  
  has_many :movement_products
  

def self.search(params)        
    suppliers = Movement.where("name  LIKE ?","%#{params[:search]}%") if params[:search].present?
    suppliers
end

  def correlativo
        voided= Voided.new()
        voided.numero=Voided.find(1).numero.to_i + 1
        lcnumero=voided.numero.to_s
        Voided.where(:id=>'1').update_all(:numero =>lcnumero)        
  end
  
  
  def delete_product()
    movement_products = MovementProduct.where(movement_id: self.id)
    
    for ip in movement_products
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        unidad_id  = parts[2]
        peso     = parts[3]
        price    = parts[4]
        discount = parts[5]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          new_movement_product = MovementProduct.new(:movement_id => self.id, :product_id => product.id, :price => price.to_f, :quantity => quantity.to_i,:unidad_id=> unidad_id.to_i,:peso=>peso.to_i, :discount => discount.to_f, :total => total.to_f)
          new_movement_product.save

        rescue
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.supplier.name}"
  end

  

  def get_products   
    @itemproducts = MovementProduct.find_by_sql(['Select movement_products.price,movement_products.quantity,movement_products.discount,
movement_products.total,movement_products.unidad_id,movement_products.peso,products.name  
from movement_products INNER JOIN products ON movement_products.product_id = products.id 
where movement_products.movement_id = ?', self.id ])


    return @itemproducts

  end
  
  def get_movement_products
   	movement_products = MovementProduct.where(movement_id:  self.id)    
    return movement_products
  end

  
  def products_lines
    products = []
    movement_products =MovementProduct.where(movement_id:  self.id)
    
    movement_products.each do | ip |

      ip.product[:price]    = ip.price
      ip.product[:quantity] = ip.quantity
      ip.product[:unidad_id] = ip.unidad_id 
      ip.product[:peso]     = ip.peso
      ip.product[:discount] = ip.discount
      ip.product[:total]    = ip.total
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}|BRK|#{ip.product.unidad_id}|BRK|#{ip.product.peso}|BRK|#{ip.product.price}|BRK|#{ip.product.discount}")
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
  def get_truck2(truck2_id)

    @truck2= Truck.find(truck2_id).placa
    return  @truck2
    
  end
  
  
  
  def process

    if(self.processed == "1" or self.processed == true)
      movement_products = MovementProduct.where(movement_id: self.id)
    
      for ip in movement_products
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


