class Deliverymine < ActiveRecord::Base

	belongs_to :delivery
	belongs_to :mine, :class_name => 'Delivery'		

end
