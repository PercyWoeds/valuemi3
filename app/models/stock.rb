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

def get_ingresos(id) 
 @purchases =Purchase.find_by_sql(['Select purchases.date1,purchases.documento,
            purchase_details.quantity,purchase_details.price_without_tax 
            from purchases 
            INNER JOIN purchase_details ON   purchases.id = purchase_details.purchase_id
            WHERE  purchase_details.purchase_id = ?', id  ])
    
    return @purchases
 end 

end
