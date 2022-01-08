*SET STEP ON 

cServidor = "SERVER\SQLEXPRESS"	
cUsuario  = "sa"
cPassword = "sa1234$"
cBaseDeDatos = "RSCONCAR"
*
cCadenaConexion = "driver={SQL Server};server=" + cServidor + ";uid=" + cUsuario + ";pwd=" + cPassword + ";DATABASE=" + cBaseDeDatos

nConexion = Sqlstringconnect(cCadenaConexion)

IF nConexion < 0
	MESSAGEBOX("No se pudo conectar a SQL Server", 16, "")
	RETURN 
ENDIF 

cAnioMes = "1608"
cTabla = "ct0003vent"+cAnioMes
cSubd1 = "05"	&& serie 401 - 405 - 410
cSubd2 = "06"	&& serie 402 - 407 - 409
cSubd3 = "29"	&& serie 411
cSubd4 = "39"	&& serie 511
cSubd5 = "49"   && serie 502
cSubd6 = "84"   && 

* falta serie 403, 501,  

cSql = "select vt_feccom, vt_tipdoc, vt_serdoc, vt_numdoc, vt_nombre, vt_mnafec, vt_mninaf, vt_mnigv, vt_mntotal, vt_tipcam "
cSql = cSql + "from " +cTabla + " where (vt_subdia=" + cSubd1 
cSql = cSql + "or vt_subdia=" + cSubd2
cSql = cSql + "or vt_subdia=" + cSubd3
cSql = cSql + "or vt_subdia=" + cSubd4
cSql = cSql + "or vt_subdia=" + cSubd5
cSql = cSql + "or vt_subdia=" + cSubd6 + ")" 
cSql = cSql + " and vt_tipdoc like '%FT%' order by vt_serdoc, vt_numdoc"   && and vt_serdoc like " + cSubd

nSuccess = SQLExec(nConexion, cSql, 'MiCursor')

If nSuccess > 0
	Select 'MiCursor'
	Browse

	SQLDisconnect(nConexion)
Else
	Messagebox('Sql Error')
Endif

