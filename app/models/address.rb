class Address < ActiveRecord::Base
  validates_presence_of  :address 
  before_save :set_full_address
  belongs_to :company 	 
  belongs_to :customer 
  belongs_to :user
 

	

	private 

	def set_full_address
		self.full_address ="#{self.address} #{self.address2}#{self.state}#{self.city}".strip

	end 

end
