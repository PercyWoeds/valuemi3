set proc to libreria 
PUBLIC _numero_conexion
nombre_servidor ='192.168.1.80\SQLEXPRESS'
nombre_base_datos ='XPUMPDB_2'
nombre_usuario ='userpec'
clave_usuario ='123456'

BaseDatos = conectar_base_datos(nombre_servidor,nombre_base_datos,nombre_usuario,clave_usuario)

lcCara = '1' 
lcFecha = "2019/01/30"

aSql =	SQLExec(_numero_conexion,  "SELECT * FROM JOURNAL WHERE MONTH(ffecha_journal) >= 12  and YEAR(ffecha_journal) = 2021 "  , "tempo"  )	

sele Tempo
GO bott
BROWSE

COPY TO c:\pventa\tmp0320

USE


=SQLDISCONNECT(_numero_conexion) 




