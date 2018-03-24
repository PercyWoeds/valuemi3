class FacturaDetail < ActiveRecord::Base
    
    
    belongs_to :factura 
    belongs_to :product
    
end
