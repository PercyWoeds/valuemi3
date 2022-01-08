***********************************************************
*	Actualiza Saldo al momento de ingresar al sistema-Tienda
***********************************************************
SET OPTI ON
USE bd0002!ma03 IN 1 EXCL
SELECT ma03
Set order to tag cod_prod
If !file(lcRed+'\ma03.dbf')
	=messagebox('No se puede Abrir Archivo de Movimiento de Tienda.'+chr(13)+chr(13)+;
				'Fuente : No se tiene acceso a la Red. RUTA : ' +LCRED,26,'Error')
	retu
Endi
USE lcRed+'\bd0001!ma03' IN 2 
Set order to tag cod_prod
Sele 2
Set filt to unidad=spac(2)
go top
Do While  !Eof()
	scat memvar 								
	Sele 1
	If !Seek(m.cod_prod)
		Appe blan
		repl cod_prod with m.cod_prod
	Endi
	Repl codigo1   with m.codigo1
	Repl codigo2   with m.codigo2
	repl cod_dep   with m.cod_Dep
	repl cod_lin   with m.cod_lin
	repl nom_prod  with m.nom_prod
	repl nom_corto with m.nom_corto
	repl unidad    with m.unidad
	repl cantxunid with m.cantxunid
	If str(m.precio)='**********'
		m.precio=0
	Endi
	repl precio    with m.precio
	repl precio1   with m.precio1
	repl precio2   with m.precio2
	repl dscto     with m.dscto
	repl costo_pro with m.costo_pro
	repl costo_ult with m.costo_ult
	repl margen    with m.margen
	repl ini_00    with m.ini_00
	repl ini_01    with m.ini_01
	repl ini_02    with m.ini_02
	repl ini_03    with m.ini_03
	repl ini_04    with m.ini_04
	repl Com_00	   with m.com_00
	repl Com_01	   with m.com_01
	repl Com_02	   with m.com_02 
	repl Com_03	   with m.com_03
	repl Com_04	   with m.com_04
	repl Egr_00    with m.egr_00
	repl Egr_01    with m.egr_01
	repl Egr_02    with m.egr_02
	repl Egr_03    with m.egr_03
	repl Egr_04    with m.egr_04
	repl Ing_00    with m.ing_00
	repl Ing_01    with m.ing_01
	repl Ing_02    with m.ing_02
	repl Ing_03    with m.ing_03
	repl Ing_04    with m.ing_04
	repl Aju_00    with m.aju_00
	repl Aju_01    with m.aju_01
	repl Aju_02    with m.aju_02
	repl Aju_03    with m.aju_03
	repl Aju_04    with m.aju_04
	repl mn_costo  with m.mn_costo
	repl est_prod  with m.est_prod
	cCalstk00=m.ini_00-m.ven_00+m.com_00-m.egr_00+m.ing_00+m.aju_00		
	cCalstk01=m.ini_01-m.ven_01+m.com_01-m.egr_01+m.ing_01+m.aju_01		
	cCalstk02=m.ini_02-m.ven_02+m.com_02-m.egr_02+m.ing_02+m.aju_02		
	cCalstk03=m.ini_03-m.ven_03+m.com_03-m.egr_03+m.ing_03+m.aju_03														
	repl  sal_00 with  cCalstk00
	repl  sal_01 with  cCalstk01
	repl  sal_02 with  cCalstk02
	repl  sal_03 with  cCalstk03												
	repl  sal_04 with  cCalstk00+cCalstk01+cCalstk02+cCalstk03	
	Sele 2
	wait wind 'Actualizando Stock de Productos'+m.cod_prod nowait
	IF M.UNIDAD=SPAC(2)
		REPL unidad with 'SI'
	ENDIF	
	If !eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
use
Sele 2
use

USE ma05 IN 1
USE lcRed+'\bd0001!ma05' IN 2 
Sele 2
Set orde To Tag cod_cli
Go Top
Do while !eof()
	Scat Memvar
	Sele 1
	IF M.importa=spac(1)
			Appe Blan
			Gath Memv
			Wait wind "Actualizando Maestro de Clientes " nowait
	Endif		
	Sele 2
	If m.importa=spac(1)
		repl importa with '*'
	Endi
	If !Eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
Use
Sele 2
use

USE ma06 IN 1
USE lcRed+'\bd0001!ma06' IN 2 
Sele 2
Set orde To Tag cod_emp
Go Top
Do while !eof()
	Scat Memvar
	Sele 1
	IF M.importa=spac(1)
			Appe Blan
			Gath Memv
			Wait wind "Actualizando Maestro de Personal " nowait
	Endif		
	Sele 2
	If m.importa=spac(1)
		repl importa with  '*'
	Endi
	If !Eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
Use
Sele 2
use

*****Departamentos

USE ma04 IN 1
USE lcRed+'\bd0001!ma04' IN 2 
Sele 2
Set orde To Tag cod_dep
Go Top
Do while !eof()
	Scat Memvar
	Sele 1
	IF M.importa=spac(1)
			Appe Blan
			Gath Memv
			Wait wind "Actualizando Maestro de Departamentos " nowait
	Endif		
	Sele 2
	If m.importa=spac(1)
		repl importa with '*'
	Endi
	If !Eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
Use
Sele 2
use

* Tarjetas
USE ma10t IN 1
USE lcRed+'\bd0001!ma10' IN 2 
Sele 2
Set orde To Tag codtar
Go Top
Do while !eof()
	Scat Memvar
	Sele 1
	IF M.importa=spac(1)
			Appe Blan
			Gath Memv
			Wait wind "Actualizando Maestro de Personal " nowait
	Endif		
	Sele 2
	If m.importa=spac(1)
		repl importa with '*'
	Endi
	If !Eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
Use
Sele 2
use
*********Usuarios
IF USED('USUARIOS')
	use in usuarios
endi
USE usuarios IN 1
USE lcRed+'\bd0001!usuarios' IN 2 
Sele 2
Go Top
Do while !eof()
	Scat Memvar
	Sele 1
	IF M.importa=spac(1)
			Appe Blan
			Gath Memv
			Wait wind "Actualizando Usuarios " nowait
	Endif		
	Sele 2
	If m.importa=spac(1)
		repl importa with '*'
	Endi
	If !Eof()
		skip
	Else
		exit
	Endi
Endd
Sele 1
Use
Sele 2
use




