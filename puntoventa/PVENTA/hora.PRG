FUNCTION Hora 
PARAMETERS cTiempo 
PRIVATE cHora 
cHora = SUBSTR(cTiempo,1,2) 
RETURN IIF(cHora < "13",STR(Val(cHora),2),STR(Val(cHora)-12,2))+":"+; 
SUBSTR(cTiempo,4,2)+IIF(cHora < "13"," a.m."," p.m.") 