para fecha1
wait wind "Procesando ... :" nowait
******** PRODUCTO VENDIDOS ***********************************
SELECT td, fecha,turno, cod_prod,cod_Dep,;
 Sum(importe) importe, sum(cantidad) cantidad;
 FROM MO01RB;
 Where fecha=fecha1 and importe>0;
 GROUP BY fecha, cod_prod;
 ORDER BY fecha, cod_prod;
 INTO Tabl CntProducto
 
********PRODUCTOS DEVUELTOS *********************************
SELECT td, fecha,turno, cod_prod,cod_Dep,;
 Sum(importe) importe, sum(cantidad) cantidad;
 FROM MO01RB;
 Where fecha=fecha1 and importe<0;
 GROUP BY fecha, cod_prod;
 ORDER BY fecha, cod_prod;
 INTO Curs CntProductoDevo
************************************************************
SET DATE ANSI
Sele CntProducto
Inde on DTOC(FECHA)+cod_prod To tempo.Idx
Sele CntProductoDevo
Go top
Do whil !eof()
   stor FECHA to LcFecha
   STOR Cod_Prod to lcProd
   Stor cantidad to LcSaldo      
   Stor importe  to LcImporte
	   Sele CntProducto
	   If seek (dtoc(LcFecha)+lcProd) 
	   	   Repl cantidad with cantidad - LcSaldo 
	   	   Repl Importe  with Importe  + LcImporte
		ELSE
			APPEND BLANK
			REPLACE TD WITH CntProductoDevo.TD	,;
					FECHA WITH CntProductoDevo.FECHA	,;
					COD_PROD	WITH CntProductoDevo.COD_PROD	,;
					COD_DEP		WITH CntProductoDevo.COD_DEP	,;
					IMPORTE		WITH CntProductoDevo.IMPORTE	,;
					CANTIDAD	WITH CntProductoDevo.CANTIDAD   	   
	   Endi 	   
	   Sele CntProductoDevo
	   If !eof()
	   	  Skip
	   Else
	      exit
	   Endif
Endd

************************************************************ 
**    DEPARTAMENTO
************************************************************ 
SELECT td, fecha,turno,cod_prod,cod_Dep,;
 Sum(importe) importe, sum(cantidad) cantidad;
 FROM MO01RB;
 Where fecha=fecha1 and  importe>0; 
 GROUP BY fecha, cod_Dep;
 ORDER BY fecha, cod_Dep;
 INTO Tabl CntDepa
*****
SELECT td, fecha,turno, cod_prod,cod_Dep,;
 Sum(importe) importe, sum(cantidad) cantidad;
 FROM MO01RB;
 Where fecha=fecha1  and importe<0;
 GROUP BY fecha, cod_prod;
 ORDER BY fecha, cod_prod;
 INTO Curs CntDepaDev
 
************************************************************
Sele CntDepa
*Inde on DTOC(FECHA)+cod_prod To tempo1.Idx
Inde on DTOC(FECHA)+cod_dep To tempo1.Idx
Sele CntDepaDev
Go top
Do whil !eof()
   stor FECHA to LcFecha
*   STOR Cod_Prod to lcProd
   STOR Cod_Dep to lcDep
   Stor cantidad to LcSaldo      
   Stor importe  to LcImporte
	   Sele CntDepa
	   If seek (dtoc(LcFecha)+lcDep) 
	   	   Repl cantidad with cantidad - LcSaldo 
	   	   Repl Importe  with Importe  + LcImporte
	   Endi 	   
	   Sele CntDepaDev
	   If !Eof()
	   	  Skip
	   Else
	      Exit
	   Endif
Enddo
*****************************************
SELECT fecha,td,serie,FPAGO,min(numero) minimo, max(numero) maximo, SUM(importe) importe;
 FROM MO01RB;
 WHERE fecha=fecha1 ;
 GROUP BY fecha, serie,TD ;
 ORDER BY fecha, serie,td into cursor tmo01ta
 
*******Contador de Creditos
DIME NOTA[1]
DIME NOTA1[1]
DIME CRED[1]
DIME DEV[1]
DIME DEV1[1]
DIME FM[1]
DIME FM1[1]

DIME Dolar1[1]
 NOTA[1]=0
 NOTA1[1]=0
 CRED[1]=0
 DEV[1]=0
 DEV1[1]=0
 FM[1]=0
 FM1[1]=0
 Dolar1[1]=0
***********************
SELECT COUNT(dist(numero)) ITEM;
 FROM MO01RB;
 WHERE fecha=fecha1 AND TD='N' AND IMPORTE<0 ;
 GROUP BY fecha,TD;
 ORDER BY fecha,TD into ARRA NOTA
 
SELECT COUNT(dist(numero)) ITEM;
 FROM MO01RB ;
 WHERE fecha=fecha1 AND TD='N' AND IMPORTE>0;
 GROUP BY fecha,TD;
 ORDER BY fecha,TD into ARRA NOTA1
 
 &&Suma de creditos
SELECT SUM(importe) importe;
 FROM MO01RB ;
 WHERE fecha=fecha1  AND TD='N';
 GROUP BY fecha,TD;
 ORDER BY fecha,TD INTO ARRA CRED
*********Devoluciones 
SELECT COUNT(dist(numero)) ITEM;
 FROM MO01RB ;
 WHERE fecha=fecha1  AND FPAGO='99' ;
 GROUP BY fecha,FPAGO;
 ORDER BY fecha,FPAGO INTO ARRA DEV

SELECT SUM(importe) importe;
 FROM MO01RB ;
 WHERE fecha=fecha1 AND fpago='99';
 GROUP BY fecha,FPAGO;
 ORDER BY fecha,FPAGO INTO ARRA DEV1
*********Facturas Manuales ******************
SELECT TD,COUNT(dist(numero)) ITEM , SUM(IMPORTE) IMPORTE ;
 FROM MO01RB ;
 WHERE fecha=fecha1  AND FPAGO='98' ;
 GROUP BY fecha,TD;
 ORDER BY fecha,TD INTO CURS FM

&&Dolares Importe soles
 SELECT sum(importe) importe ;
 FROM MO01RB ;
 WHERE fecha=fecha1 aND fpago='02';
 GROUP BY fecha,fpago;
 ORDER BY fecha,fpago into arra dolar1

**************Efectivo S/. ************************
SELECT fecha,COUNT(dist(numero)) ITEM,fpago,serie,CAJA,cod_tar, SUM(importe) importe;
 FROM MO01RB ;
 WHERE fecha=fecha1  AND (fpago<>'02') and (td='B' or td='F' ) ;
 GROUP BY fecha;
 ORDER BY fecha into cursor tmo01tb
*******************DOLARES $ ***********************
SELECT distinc fecha,td,dolar,fpago,serie,Caja,cod_tar,count(distinct(numero)) cantidad,dolares ;
 FROM MO01RB ;
 WHERE fecha=fecha1 AND fpago='02' ;
 GROUP BY fecha,dolares;
 ORDER BY fecha,fpago into cursor tmo01tc
Set date brit
