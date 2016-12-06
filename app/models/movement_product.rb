class MovementProduct < ActiveRecord::Base
 validates_presence_of :movement_id, :product_id, :price, :quantity, :discount, :total
  
  belongs_to :movement 
  belongs_to :product

end