class OutputDetail < ActiveRecord::Base

  validates_presence_of :output_id, :product_id, :price, :quantity,  :total
  
  belongs_to :output 
  belongs_to :product
end
