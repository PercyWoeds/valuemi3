*********************
*    numeros.prg    *
*********************
function numeros
para paga,letras 
uu=''
uu0=''
uu1='UN '
uu2='DOS '
uu3='TRES '
uu4='CUATRO '
uu5='CINCO '
uu6='SEIS '
uu7='SIETE '
uu8='OCHO '
uu9='NUEVE '
ud=''
ud0=''
ud11='ONCE '
ud12='DOCE '
ud13='TRECE '
ud14='CATORCE '
ud15='QUINCE '
ud16='DIECISEIS '
ud17='DIECISIETE '
ud18='DIECIOCHO '
ud19='DIECINUEVE '
ud10='DIEZ '
ud20='VEINTE '
ud30='TREINTA '
ud40='CUARENTA '
ud50='CINCUENTA '
ud60='SESENTA '
ud70='SETENTA '
ud80='OCHENTA '
ud90='NOVENTA '
ud2='VEINTI'
ud3='TREINTI'
ud4='CUARENTI'
ud5='CINCUENTI'
ud6='SESENTI'
ud7='SETENTI'
ud8='OCHENTI'
ud9='NOVENTI'
uc=''
uc0=''
uc00='CIEN '
uc1='CIENTO '
uc2='DOSCIENTOS '
uc3='TRESCIENTOS '
uc4='CUATROCIENTOS '
uc5='QUINIENTOS '
uc6='SEISCIENTOS '
uc7='SETECIENTOS '
uc8='OCHOCIENTOS '
uc9='NOVECIENTOS '
um1=''
mm1='MILLON'
a=0
a=paga
b=str(int(a))
entero=int(a)
CENTIMO=A-INT(A)
if CENTIMO>0
      if centimo>.10  
         CENTIMO=' Y '+trans((CENTIMO*100),'99')+'/100'
        else
         if centimo<.10  
            CENTIMO=' Y 0'+trans((CENTIMO*100),'9')+'/100'
           else
            CENTIMO=' Y '+trans((CENTIMO*100),'99')+'/100'
         endi   
      endi   
  else
    CENTIMO=' Y 00/100'
endi    
canti=' '
for q=1 to len(b)-1
    n=''
    rango=subs(b,q+1,3) 
    do cuenta
       canti=canti+n
       if len(ltrim(b))>6.and.q<=3
           canti=canti+iif(subs(rango,1,1)=' '.and.subs(rango,2,1)=' '.and.subs(rango,3,1)='1','MILLON ','MILLONES ')
       else   
          if val(rango)>0.and.q<=6
             canti=canti+'MIL '
          endif    
       endif
       q=q+2
endf
money=' NUEVOS SOLES '
letras=canti+centimo+money
paga=0
return(letras)
******************************************
procedure cuenta
        *1 
	    if subs(rango,1,1)='1'.and.subs(rango,2,1)='0'.and.subs(rango,3,1)='0'
	       n=uc00
	       retu
	    endif
	    *2
	    if subs(rango,1,1)>'1'.and.subs(rango,2,1)='0'.and.subs(rango,3,1)='0'
	       c=subs(rango,1,1)      
	       n=uc&c
	       retu
	    endif
	    *3
	    if subs(rango,1,1)>='1'.and.subs(rango,2,1)='0'.and.subs(rango,3,1)>'0'
	       c=subs(rango,1,1)      
		   u=subs(rango,3,1)
	       n=uc&c+uu&u
	       retu
	    endif
	    *4
	    if subs(rango,1,1)>=' '.and.subs(rango,2,1)>='1'.and.subs(rango,3,1)='0'
	       c=subs(rango,1,1)      
	       d=subs(rango,2,2)
	       n=uc&c+ud&d
	       retu
	    endif
	    *5
	    if subs(rango,1,1)>=' '.and.subs(rango,2,1)='1'.and.subs(rango,3,1)>='0'
	       c=subs(rango,1,1)      
		   u=subs(rango,3,1)
	       n=uc&c+ud1&u
	       retu
	    endif
	    *6
	    if subs(rango,1,1)>=' '.and.subs(rango,2,1)>=' '.and.subs(rango,3,1)>'0'
	            c=subs(rango,1,1)      
	            d=subs(rango,2,1)
			    u=subs(rango,3,1)
	            n=uc&c+ud&d+uu&u
	       retu
	    endif           
retu
*eop(numeros.prg)