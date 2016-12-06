class PurchaseorderDetail < ActiveRecord::Base

	validates_presence_of :purchaseorder_id, :product_id, :price, :quantity, :discount, :total
  
  belongs_to :purchaseorder
  belongs_to :product
end

