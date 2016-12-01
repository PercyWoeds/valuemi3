class Employee < ActiveRecord::Base

	before_save :set_full_name

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		

	end 


end
