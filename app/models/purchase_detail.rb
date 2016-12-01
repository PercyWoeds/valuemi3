

class PurchaseDetail < ActiveRecord::Base
 validates_presence_of :purchase_id, :product_id, :price_with_tax, :quantity, :total
  
  belongs_to :purchase	
  belongs_to :product
end
