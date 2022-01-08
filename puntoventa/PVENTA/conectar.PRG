set proc to libreria 

nombre_servidor ='192.168.1.80\SQLEXPRESS'
nombre_base_datos ='XPUMPDB_2'
nombre_usuario ='userpec'
clave_usuario ='123456'

BaseDatos = conectar_base_datos(nombre_servidor,nombre_base_datos,nombre_usuario,clave_usuario)

lcCara = '1' 

aSql =	SQLExec(_numero_conexion,  "SELECT * FROM JOURNAL WHERE MONTH(ffecha_journal) = 3  and YEAR(ffecha_journal) = 2020  " , "tempo"  )	

sele Tempo
GO TOP
COPY TO ventas2019 TYPE XLS 


=SQLDISCONNECT(_numero_conexion) 




