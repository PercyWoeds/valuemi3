*   Programa: INICIO DE LISTADORES                              *
*****************************************************************

SET library to rawprint5.fll additive
SET PRINTER TO FILE &filetxt
SET CONSOLE OFF
SET DEVICE TO PRINT
SET MARGIN TO 0
SET PRINT ON
??CHR(27)+'@'+CHR(27)+'M'+CHR(18)
SET PRINT OFF
RETURN

