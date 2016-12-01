class Deliveryship < ActiveRecord::Base
	belongs_to :factura
	belongs_to :delivery 
end
