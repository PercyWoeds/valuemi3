set proc to libreria 
SET EXCLUSIVE OFF 
 SELECT 1
 USE x:\ma03
 
 SELECT 2
 USE y:\ma03
 
 SELECT 3
 USE z:\ma03



nombre_servidor ='192.168.1.9\SQLEXPRESS'
nombre_base_datos ='XPUMP_DB'
nombre_usuario ='sa'
clave_usuario ='123456'

BaseDatos = conectar_base_datos(nombre_servidor,nombre_base_datos,nombre_usuario,clave_usuario)


  aSql =	SQLExec(_numero_conexion,  " SELECT * FROM PRODUCTO ","tempo"  )	
  
 IF aSql = -1 
 	=MESSAGEBOX("Ha ocurrido un error en el cierre  ",16)
 	
 ENDIF
 
   
SELECT tempo
GO top

DO WHILE !EOF()
	STORE nid_producto TO lcCod
	STORE dPrecio_producto TO lcPrecio
	
	SELECT 1
	REPLACE precio WITH lcPrecio FOR VAL(codcem)= lcCod  		
	SELECT 2
	REPLACE precio WITH lcPrecio FOR VAL(codcem)= lcCod  		
	SELECT 3
	REPLACE precio WITH lcPrecio FOR VAL(codcem)= lcCod  		
	
	
	WAIT WINDOW "Actualizando Precio ..."+STR(lcCod) NOWAIT 

	SELECT tempo
	IF !EOF()	
		skip
	ELSE
		EXIT 
	ENDIF 

ENDDO  

SELECT ma03
USE 

=SQLDISCONNECT(_numero_conexion) 




