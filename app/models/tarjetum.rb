class Tarjetum < ActiveRecord::Base
     belongs_to :venta_producto 
     belongs_to :factura 

     has_many :sellvales
     
end
