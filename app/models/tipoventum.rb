class Tipoventum < ActiveRecord::Base
    validates_presence_of :code, :nombre 
    validates_uniqueness_of :code
    
    belongs_to :factura 
    
end
