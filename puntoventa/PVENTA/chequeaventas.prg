SET STEP ON 



SELECT * FROM cara		;
	WHERE isla = lcIsla	;
	ORDER BY Cara		;
	INTO CURSOR TmpIsla
*
*
nombre_servidor ='192.168.1.80\SQLEXPRESS'
nombre_base_datos ='XPUMPDB_2'
nombre_usuario ='userpec'
clave_usuario ='123456'

BaseDatos = conectar_base_datos(nombre_servidor,nombre_base_datos,nombre_usuario,clave_usuario)


SELECT Tmpisla
GO TOP 


DO WHILE !EOF()

	STORE Cara TO LcCara
	
	
		aSql =	SQLExec(_numero_conexion, "SELECT * FROM JOURNAL WHERE nEstadoDesp IS NULL and nLado_Surtidor =  " + lcCara  , "tempoSQL" )	
						
		 if aSql = -1		
		 	wait wind "No existen transacciones pendientes "

			return
 		 endif  
			
		SELE tempoSQL									
		go top 			
		
		IF RECC()>0
			WAIT WINDOW "EXISTEN TRANSACCION NO REGISTRADAS!!"
			
			
			
			
			STORE tempoSQL.nPosicion_Manguera	to wcara
			STORE dtoc(tempoSql.fFecha_Journal) to wfecha
			STORE gturno   to wturno
			STORE tempoSQl.nLado_Surtidor  to Wnumero
			STORE tempoSQl.nId_journal     to wId_Journal
			
			STORE tempoSql.fFecha_Journal  to whora
			STORE tempoSql.nId_Producto TO nValCod
			*-----------------------------
			   
			wsoles 		= dMonto_Journal
			wGalones 	= dVolumen_Journal
			wPrecio 	= dPrecio_Journal
			LcIdJournal = tempoSql.nId_Journal
			
			
			
		 	SELECT ma03
		 	GO TOP 
		 	LOCATE FOR VAL(CODCEM) == nValCod && codigo puente
		 	IF FOUND()
		 		wproducto = ALLTRIM(ma03.COD_PROD)
		 		wNomProd  = ma03.NOM_CORTO
		 	ELSE
			 	wproducto = "  "
			 	wNomProd  = "  "
		 	ENDIF
		
			DO CASE 
	
			CASE ALLTRIM(thisform.txtCodigoProducto.Value) == WPRODUCTO
				SELECT SERIE,NUMERO FROM MO02T WHERE SUBSTR(SERIE,1,2)=="TX" AND CAJA=="99" INTO CURSOR AEXISTEFACTURA
				
			CASE ALLTRIM(thisform.txtCodigoProducto.Value) == WPRODUCTO
				SELECT SERIE,NUMERO FROM MO02T WHERE SUBSTR(SERIE,1,2)=="TX" AND CAJA=="99" INTO CURSOR AEXISTEFACTURA
				
			CASE ALLTRIM(thisform.txtCodigoProducto.Value) == WPRODUCTO
				SELECT SERIE,NUMERO FROM MO02T WHERE SUBSTR(SERIE,1,2)=="TX" AND CAJA=="99" INTO CURSOR AEXISTEFACTURA

			OTHERWISE 
				SELECT SERIE,NUMERO FROM MO02T WHERE SUBSTR(SERIE,1,2)=="BB" AND CAJA=="99" INTO CURSOR AEXISTEFACTURA
			
			ENDCASE 

			SELECT AEXISTEFACTURA
			
			GO TOP
			STORE SERIE  TO LCSERIEFACT
			STORE NUMERO TO LCNUMEROFACT
		
		**********************************

		*
*		SELECT 99
*		if used('ma03')
*			use in  ma03
*		ENDIF 
*		USE ma03
*		SET ORDER TO tag cod_prod
		
		SELECT 0
		USE mo01i EXCLUSIVE 
		ZAP 
		APPEND BLANK
		REPLACE	cara 	With STR(wcara,2)	
		REPLACE numero1 with ALLTRIM(STR(wnumero,6))
		
		REPLACE Turno   with wturno	
		REPLACE Hora    with SUBSTR(ttoc(whora),12,2)+SUBSTR(ttoc(whora),15,2)
				
		REPLACE fec_tran WITH SUBS(wfecha,1,2) + SUBS(wfecha,4,2)+SUBS(wfecha,9,2)
		
		REPLACE cod_prod with wproducto
		REPLACE	nom_prod WITH wNomProd

		REPLACE precio   with wprecio	
		REPLACE cantidad with wgalones	
		REPLACE importe  with wsoles
		
		REPLACE odometro with STR(wid_journal,6)
				
		REPLACE dia 	 with datetime()
		
		*****
		REPLACE cod_cli WITH "C_000001"	,;
			ruc WITH "C_000001"		

		REPLACE td 	  	WITH wtipodoc				,;
				fecha   with gfecha					,;
				turno   with Gturno					,;
				cod_emp with gCodEmp				,;
				caja	WITH "99" && ver si gcaja variable existe 

		REPLACE serie	WITH LCSERIEFACT	,;
			numero	WITH LCNUMEROFACT 
			
		
		REPLACE igv 	with gigv					,;
			dolar   with thisform.text15.value	,;
			dia 	with datetime()				,;
			fpago   with wfpago
		
		REPLACE COD_DEP WITH "99", COD_LIN WITH "99"			
		REPLACE COD_SUCU WITH gSucursal	,;
				ISLA WITH lcIsla			
    	replace mcliente WITH 0
		repl	nrotx    with 0
	
		 DO CASE 
		 CASE ALLTRIM() = "01"
		 	lnPrecio =  thisform.txtPrecioProducto.Value 			 	
	 
		 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "02"
		 	lnPrecio =  thisform.txtPrecioProducto.Value - 0.80			 	
		 	 
		 	
		 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "03" && diesel 
		 	lnPrecio = thisform.txtPrecioProducto.Value
	
		 	
		 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "04"&& 95
		 	lnPrecio = thisform.txtPrecioProducto.Value	- 1.00
		 	
	 	 	
	 	 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "05" 
	 	  	lnPrecio = thisform.txtPrecioProducto.Value	
	 	  	
	 	 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "06"	 &&98	 
	 	  	lnPrecio = thisform.txtPrecioProducto.Value	-1.20
	 	  	
	 	 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "07" 
	 	  	lnPrecio = thisform.txtPrecioProducto.Value	

	 	 CASE ALLTRIM(thisform.txtCodigoProducto.Value) = "08"
	 	 	lnPrecio = thisform.txtPrecioProducto.Value	 - 0.15
	 	 OTHERWISE
	 	

	 	 	lnPrecio = thisform.txtPrecioProducto.Value	 
	 	  	
     ENDCASE
     lnCantidad = thisform.txtTotalImporte.Value / Thisform.txtPrecioProducto.value 		 	
     lnImporte = lnPrecio * ROUND(lnCantidad,2)
		 	
	
	REPLACE precio3  WITH lnPrecio
	REPLACE importe3 WITH lnImporte 
	

		
		*****
			
			
			
						
			RETURN 
		ENDIF 
					
				
	
	
		SELECT TmpIsla	
		IF !EOF()
			skip
		ELSE
			exit
		ENDIF
	
	 		
ENDDO  

SQLDISCONNECT(_numero_conexion)
