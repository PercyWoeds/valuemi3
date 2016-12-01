class Order < ActiveRecord::Base
	
	attr_accessible :name, :address, :email,:pay_type,:subtotal,:tax,:total,:user_id

 	self.per_page = 20
	  
	  belongs_to :company
	  belongs_to :location
	  belongs_to :division
	  belongs_to :customer
	  belongs_to :user
	  
	  has_many :invoice_products

  
	PAYMENT_TYPES = [ "Efectivo", "Credito Visa", "Credito Mastercard" ]

	#validates :name, :address, :email, presence: true
	
	validates :pay_type, inclusion: PAYMENT_TYPES
	has_many :line_items, dependent: :destroy
	
	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
		item.cart_id = nil
		line_items << item
		end
	end

	 def get_products    
	    @itemorders = Order.find_by_sql(['Select products.price,line_items.quantity,line_items.quantity*line_items.price as total,products.name  from line_items INNER JOIN products ON line_items.product_id = products.id where line_items.order_id = ?', self.id ])	   

	    return @itemorders
	  end
	 
end
