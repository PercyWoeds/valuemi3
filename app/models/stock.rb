class Stock < ActiveRecord::Base


self.per_page = 20

belongs_to :document 

belongs_to :product

  TABLE_HEADERS = ["ITEM",
                     "CODIGO",
                     "NOMBRE",
                     "CANTIDAD",                     
                     "COSTO",
                     "TOTAL",
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
