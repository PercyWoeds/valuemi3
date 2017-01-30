class Stock < ActiveRecord::Base


belongs_to :product
belongs_to :document 


  TABLE_HEADERS = ["ITEM",
                     "NOMBRE",
                     "CANTIDAD",                     
                     "COSTO",
                     "ESTADO"]


	
  TABLE_HEADERS2 = ["ITEM",
                     "NOMBRE",
                     "TD",
                     "DOCUMENTO",
                     "INICIAL",                     
                     "INGRESO",
                     "SALIDA",
                     "SALDO "]


          

def get_estado
	if self.active == true

		return "Activo"

	else

		return "Baja"
    end 
end 

end
