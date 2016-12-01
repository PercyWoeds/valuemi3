class DeclarationDelivery < ActiveRecord::Base
	validates_presence_of :delivery_id

	belongs_to :delivery 
	belongs_to :declaration

end
