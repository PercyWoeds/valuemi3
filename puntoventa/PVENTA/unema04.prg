sELE 1
USE h:\SCG\MAES017
SET FILT TO cod_eESS="3086"
sELE 2
USE MA04
set order to cod_dep
sELE 1
GO TOP
DO  WHILE !EOF()
	STOR grupo TO WCOD
	STOR codlin TO Wgru
	STOR nombre TO Wnom
	SELE 2
	If !seek(wcod)
		APPE BLAN
		REPL cod_dep WITH Right('00'+(allt(wcod)),2)
		REPL NOM_dep WITH WNOM
		REPL COD_LIN WITH Right('00'+(allt(str(wgru))),2)
	Endi
	SELE 1
	SKIP
ENDDO
sELE 1
USE
SELE 2
USE




