WAIT WINDOW "Generando archivo..." nowait 
SET DELETED ON
SET DATE BRITISH 
SET CENTURY on
SET SAFETY off
set excl off

fecha1=CTOD('26/11/2019')

fecha2=CTOD('02/12/2019')

SELECT  td,	fecha	,turno	,cod_emp	,caja	,serie,	numero	,cod_cli	,ruc	,placa	,odometro,	cod_prod	,cantidad	,precio	,importe	,igv	,fpago,implista,cod_tar,km,chofer,tk_devol,	cod_sucu,	isla	,dni_cli,tipo;
FROM \\isla01\pventa\mo01rb WHERE  fecha >= fecha1  AND fecha<= fecha2   into tabl ventasdias1
SELECT  td,	fecha	,turno	,cod_emp	,caja	,serie,	numero	,cod_cli	,ruc	,placa	,odometro,	cod_prod	,cantidad	,precio	,importe	,igv	,fpago,implista,cod_tar,km,chofer,tk_devol,	cod_sucu,	isla	,dni_cli,tipo;
FROM \\ISLA02\pventa\mo01rb WHERE  fecha >= fecha1   AND fecha<= fecha2   into tabl ventasdias2
SELECT  td,	fecha	,turno	,cod_emp	,caja	,serie,	numero	,cod_cli	,ruc	,placa	,odometro,	cod_prod	,cantidad	,precio	,importe	,igv	,fpago,implista,cod_tar,km,chofer,tk_devol,	cod_sucu,	isla	,dni_cli,tipo;
FROM \\ISLA03\pventa\mo01rb WHERE  fecha >= fecha1 AND fecha<= fecha2   into tabl ventasdias3



SELE ventasdias1 
REPLACE ALL tipo WITH "1"
REPLACE ALL placa WITH "0" FOR EMPTY(placa)
SELE ventasdias2
REPLACE ALL tipo WITH "1"
REPLACE ALL placa WITH "0" FOR EMPTY(placa)
SELE ventasdias3 
REPLACE ALL tipo WITH "1"
REPLACE ALL placa WITH "0" FOR EMPTY(placa)
appe from ventasdias2
appe from ventasdias1

COPY TO c:\pventa\data2018.csv TYPE csv
COPY TO c:\pventa\data2018
WAIT WINDOW "Archivo procesado "
