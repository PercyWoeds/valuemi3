class Stock < ActiveRecord::Base

validates_uniqueness_of :product_id 
validates_presence_of :store_id, :product_id
 
self.per_page = 20

belongs_to :document 
belongs_to :product

  TABLE_HEADERS = ["ITEM",
                     "CODIGO",
                     "NOMBRE",
                     "UNIDAD",
                     "UBICACION",
                     "STOCK",                     
                     "COSTO",
                     "TOTAL" ]
	
            
  TABLE_HEADERS2 = ["ITEM",
                     "CODE ",
                     "NOMBRE",
                     "UND",
                     "UBICA",
                     "COSTO",
                     "INICIAL",                     
                     "INGRESO",
                     "SALIDA",
                     "STOCK  ",
                     "TOTAL  "  ]

  TABLE_HEADERS41 = ["",
                     "", 
                     "",
                     "",   
                     " ",
                     "DOCUMENTO INTERNO O SIMILAR",
                     "TIPO DE OPERACION ",
                     "",
                     "ENTRADA",
                     "",                                                    
                     "",
                     "SALIDA ",                     
                     "",                     
                     "",
                     "SALDO FINAL ",
                     ""  ]

  TABLE_HEADERS4 = ["CODIGO",
                     "DESCRIPCION", 
                     "FECHA",
                     "TIPO ",
                     "SERIE",
                     "NUMERO",
                     "TABLA 12",
                     "CANTIDAD ...",
                     "COSTO UNITARIO",                     
                     "TOTAL         ",
                     "CANTIDAD ...      ",
                     "COSTO UNITARIO",                     
                     "TOTAL         " ,                     
                     "CANTIDAD ...      ",
                     "COSTO UNITARIO ",
                     "TOTAL          "  ]
        

  TABLE_HEADERS5 = [ "FECHA DE CORTE" ,
                    "HORA DE CORTE",
                    "EXISTENCIAS DEL PRODUCTO
                    SEGUN INVENTARIO FISICO ANTERIOR",
                    "TOTAL DE INGRESOS DEL PRODUCTO
                    (COMPRAS)  ",
                    "Σ DEVOLUCIONES DEL PRODUCTO A TANQUES 
                    (calibraciones, mantenimiento o afines) ",
                    "TOTAL DE SALIDAS DEL PRODUCTO
                    (VENTAS)   "
                    "ET = NUEVA EXISTENCIA TEORICA",
                    "EF = NUEVA EXISTENCIA FISICA, 
                    SEGÚN VARILLAJE ",
                    " Di = DIFERENCIA ENTRE 
                    EXISTENCIA TEORICA Y FISICA ",
                    "SUCESOS ",
                    "OBSERVACIONES ",
                    " FIRMA"]


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
