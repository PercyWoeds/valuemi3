*close all
*clear all
set classlib to selectora
*- Guarda en una variable el area seleccionada actual para 
*- cerrar volver a recuperarla 
lcSelec = SELECT()

*- Nombre que le vamos a poner a las columnas
LOCAL ARRAY laCabecera(2)
        	laCabecera(1) = 'Código'
        	laCabecera(2) = 'Nombre '

*- Campos a mostrar		
WAIT WIND "Seleccionando Registros" nowait
SELECT cod_prod,nom_prod ;
 FROM ma03t ;
order by nom_prod INTO CURS Tmpcur
   
sele cod_prod,nom_prod  from  tmpcur into  TABL _tmpcursor 

*- Activamos el Cursor
select _Tmpcursor

*- Instanciamos la clase miForm
frmMyForm = CREATEOBJECT("miform", @laCabecera)

frmMyForm.SHOW()

RELEASE frmMyForm

*- Mostramos el campo seleccionado
wcodprod=_tmpcursor.cod_prod
USE IN _TmpCursor

*- recupearamos tabla original seleccionada
SELECT(lcSelec)
