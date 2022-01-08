para namereport
IF INT((40-LEN(ALLTRIM(datos.NOMEMP)+" "+ALLTRIM(datos.NOMEESS)))/2) >0
@lin,INT((40-LEN(ALLTRIM(datos.NOMEMP)+" "+ALLTRIM(datos.NOMEESS)))/2) ;
	say ALLTRIM(datos.NOMEMP)+" "+ALLTRIM(datos.NOMEESS)
ELSE
	@lin,0	say ALLTRIM(datos.NOMEMP)+" "+ALLTRIM(datos.NOMEESS)

ENDif
	 
FOR i=1 TO 3
	l1 = SUBSTR(ALLTRIM(datos.DIREESS),(i*40)-39,40)
	IF !EMPTY(l1)
		lin=lin+1
		@ lin, INT((40-LEN(l1))/2) say l1				 		
	ENDIF 
NEXT 	

lin=lin+1
@lin, INT((40-LEN("Telefono: " + ALLTRIM(datos.TELEFSUCU)))/2) ;
	say "Telefono: " + ALLTRIM(datos.TELEFSUCU)

lin=lin+1
@lin, INT((40-LEN(ALLTRIM(datos.PROVIN_SUCU)))/2)	;
	say ALLTRIM(datos.PROVIN_SUCU)

lin=lin+1
@lin, INT((40-LEN("RUC. "+ ALLTRIM(datos.RUCEESS)))/2)	;
	say "RUC. "+ ALLTRIM(datos.RUCEESS)
*@ lin,0 say 'R.U.C.'+datos.ruceess+'  S:'+datos.SERIE
lin=lin+1
