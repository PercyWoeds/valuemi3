class MovementDetail < ActiveRecord::Base


validates :stock_final, numericality: true

	belongs_to :product	
	belongs_to :document

end
