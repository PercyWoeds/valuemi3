class RedentionDetail < ActiveRecord::Base
    
    belongs_to :redention 
	belongs_to :product 

	validates :product_id, presence: true
	validates :quantity, presence: true
	validates :price, presence: true

	accepts_nested_attributes_for :product 


	def subtotal
		self.quantity ? quantity * unit_price : 0
	end

	def unit_price
		if persisted?
			price
		else
			item ? item.price : 0
		end
	end
end
