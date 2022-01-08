PUBLIC x

***************************
* CONEXION A SQL BISLINKS
***************************
*
SET ENGINEBEHAVIOR 90

cServidor = "FACTURACION"
cUsuario  = "sa"
cPassword = "P3tr0c0rp"
cBaseDeDatos = "BIZLINKS"
*
cCadenaConexion = "driver={SQL Server};server=" + cServidor + ";uid=" + cUsuario + ";pwd=" + cPassword + ";DATABASE=" + cBaseDeDatos

nConexion = Sqlstringconnect(cCadenaConexion)

IF nConexion < 0
	MESSAGEBOX("No se pudo conectar a SQL Server", 16, "")
	RETURN 
ENDIF 


	cTabla = "SPE_EINVOICEHEADER"
	
	
	cSql = "select  correoEmisor,"+;
	"correoAdquiriente,"+;
	"numeroDocumentoEmisor,"+;
	"tipoDocumentoEmisor,"+;
	"tipoDocumento,"+;
	"razonSocialEmisor,"+;
	"nombreComercialEmisor,"+;
	"serieNumero,"+;
	"fechaEmision,"+;
	"ubigeoEmisor,"+;
	"direccionEmisor,"+;
	"urbanizacion,"+;
	"provinciaEmisor,"+;
	"departamentoEmisor,"+;
	"distritoEmisor,"+;
	"paisEmisor,"+;
	"numeroDocumentoAdquiriente,"+;
	"tipoDocumentoAdquiriente,"+;
	"razonSocialAdquiriente,"+;
	"direccionAdquiriente,"+;
	"ubigeoAdquiriente,"+;
	"urbanizacionAdquiriente,"+;
	"provinciaAdquiriente,"+;
	"departamentoAdquiriente,"+;
	"distritoAdquiriente,"+;
	"paisAdquiriente,"+;
	"tipoMoneda,"+;
	"totalValorVentaNetoOpGravadas,"+;
	"totalValorVentaNetoOpNoGravada,"+;
	"totalValorVentaNetoOpExoneradas,"+;
	"totalValorVentaNetoOpGratuitas,"+;
	"totalIgv,"+;
	"totalDescuentos,"+;
	"totalVenta,"+;
	"codigoAuxiliar100_1,"+;
	"textoAuxiliar100_1,"+;
	"codigoAuxiliar100_2,"+;
	"textoAuxiliar100_2,"+;
	"codigoAuxiliar500_1,"+;
	"textoAuxiliar500_1,"+;
	"totalDetraccion,"+;
	"porcentajeDetraccion,"+;
	"descripcionDetraccion,"+;
	"valorReferencialDetraccion,"+;
	"codigoLeyenda_1,"+;
	"textoLeyenda_1,"+;
	"codigoLeyenda_2,"+;
	"textoLeyenda_2,"+;
	"codigoLeyenda_3,"+;
	"textoLeyenda_3,"+;
	"codigoAuxiliar500_2,"+;
	"textoAuxiliar500_2,"+;
	"codigoAuxiliar500_3,"+;
	"textoAuxiliar500_3  "+;
	" from " +cTabla 


	nSuccess = SQLExec(nConexion, cSql, 'MiCursor')
x=cSql

	If nSuccess > 0
		Select 'MiCursor'
		Browse

		SQLDisconnect(nConexion)
	Else
		Messagebox('Sql Error')
		RETURN 
	ENDIF
	

	INSERT INTO [dbo].[SPE_EINVOICEHEADER]
           ([numeroDocumentoEmisor]
           ,[serieNumero]
           ,[tipoDocumento]
           ,[tipoDocumentoEmisor]
           ,[bl_estadoRegistro]
           ,[bl_reintento]
           ,[bl_origen]
           ,[bl_hasFileResponse]
           ,[baseImponiblePercepcion]
           ,[codigoAuxiliar100_1]
           ,[codigoAuxiliar100_10]
           ,[codigoAuxiliar100_2]
           ,[codigoAuxiliar100_3]
           ,[codigoAuxiliar100_4]
           ,[codigoAuxiliar100_5]
           ,[codigoAuxiliar100_6]
           ,[codigoAuxiliar100_7]
           ,[codigoAuxiliar100_8]
           ,[codigoAuxiliar100_9]
           ,[codigoAuxiliar250_1]
           ,[codigoAuxiliar250_10]
           ,[codigoAuxiliar250_11]
           ,[codigoAuxiliar250_12]
           ,[codigoAuxiliar250_13]
           ,[codigoAuxiliar250_14]
           ,[codigoAuxiliar250_15]
           ,[codigoAuxiliar250_16]
           ,[codigoAuxiliar250_17]
           ,[codigoAuxiliar250_18]
           ,[codigoAuxiliar250_19]
           ,[codigoAuxiliar250_2]
           ,[codigoAuxiliar250_20]
           ,[codigoAuxiliar250_21]
           ,[codigoAuxiliar250_22]
           ,[codigoAuxiliar250_23]
           ,[codigoAuxiliar250_24]
           ,[codigoAuxiliar250_25]
           ,[codigoAuxiliar250_3]
           ,[codigoAuxiliar250_4]
           ,[codigoAuxiliar250_5]
           ,[codigoAuxiliar250_6]
           ,[codigoAuxiliar250_7]
           ,[codigoAuxiliar250_8]
           ,[codigoAuxiliar250_9]
           ,[codigoAuxiliar40_1]
           ,[codigoAuxiliar40_10]
           ,[codigoAuxiliar40_11]
           ,[codigoAuxiliar40_12]
           ,[codigoAuxiliar40_13]
           ,[codigoAuxiliar40_14]
           ,[codigoAuxiliar40_15]
           ,[codigoAuxiliar40_16]
           ,[codigoAuxiliar40_17]
           ,[codigoAuxiliar40_18]
           ,[codigoAuxiliar40_19]
           ,[codigoAuxiliar40_2]
           ,[codigoAuxiliar40_20]
           ,[codigoAuxiliar40_3]
           ,[codigoAuxiliar40_4]
           ,[codigoAuxiliar40_5]
           ,[codigoAuxiliar40_6]
           ,[codigoAuxiliar40_7]
           ,[codigoAuxiliar40_8]
           ,[codigoAuxiliar40_9]
           ,[codigoAuxiliar500_1]
           ,[codigoAuxiliar500_2]
           ,[codigoAuxiliar500_3]
           ,[codigoAuxiliar500_4]
           ,[codigoAuxiliar500_5]
           ,[codigoLeyenda_1]
           ,[codigoLeyenda_10]
           ,[codigoLeyenda_11]
           ,[codigoLeyenda_12]
           ,[codigoLeyenda_13]
           ,[codigoLeyenda_14]
           ,[codigoLeyenda_15]
           ,[codigoLeyenda_16]
           ,[codigoLeyenda_17]
           ,[codigoLeyenda_18]
           ,[codigoLeyenda_19]
           ,[codigoLeyenda_2]
           ,[codigoLeyenda_20]
           ,[codigoLeyenda_3]
           ,[codigoLeyenda_4]
           ,[codigoLeyenda_5]
           ,[codigoLeyenda_6]
           ,[codigoLeyenda_7]
           ,[codigoLeyenda_8]
           ,[codigoLeyenda_9]
           ,[codigoSerieNumeroAfectado]
           ,[correoAdquiriente]
           ,[correoEmisor]
           ,[departamentoEmisor]
           ,[descripcionDetraccion]
           ,[descuentosGlobales]
           ,[direccionEmisor]
           ,[distritoEmisor]
           ,[fechaEmision]
           ,[inHabilitado]
           ,[lugarDestino]
           ,[motivoDocumento]
           ,[nombreComercialEmisor]
           ,[numeroDocumentoAdquiriente]
           ,[numeroDocumentoRefeAdicional_1]
           ,[numeroDocumentoRefeAdicional_2]
           ,[numeroDocumentoRefeAdicional_3]
           ,[numeroDocumentoRefeAdicional_4]
           ,[numeroDocumentoRefeAdicional_5]
           ,[numeroDocumentoReferenciaCorre]
           ,[numeroDocumentoReferenciaPrinc]
           ,[numeroDocumentoReferencia_1]
           ,[numeroDocumentoReferencia_2]
           ,[numeroDocumentoReferencia_3]
           ,[numeroDocumentoReferencia_4]
           ,[numeroDocumentoReferencia_5]
           ,[paisEmisor]
           ,[porcentajeDetraccion]
           ,[porcentajePercepcion]
           ,[porcentajeRetencion]
           ,[provinciaEmisor]
           ,[razonSocialAdquiriente]
           ,[razonSocialEmisor]
           ,[serieNumeroAfectado]
           ,[subTotal]
           ,[textoAdicionalLeyenda_1]
           ,[textoAdicionalLeyenda_10]
           ,[textoAdicionalLeyenda_11]
           ,[textoAdicionalLeyenda_12]
           ,[textoAdicionalLeyenda_13]
           ,[textoAdicionalLeyenda_14]
           ,[textoAdicionalLeyenda_15]
           ,[textoAdicionalLeyenda_16]
           ,[textoAdicionalLeyenda_17]
           ,[textoAdicionalLeyenda_18]
           ,[textoAdicionalLeyenda_19]
           ,[textoAdicionalLeyenda_2]
           ,[textoAdicionalLeyenda_20]
           ,[textoAdicionalLeyenda_3]
           ,[textoAdicionalLeyenda_4]
           ,[textoAdicionalLeyenda_5]
           ,[textoAdicionalLeyenda_6]
           ,[textoAdicionalLeyenda_7]
           ,[textoAdicionalLeyenda_8]
           ,[textoAdicionalLeyenda_9]
           ,[textoAuxiliar100_1]
           ,[textoAuxiliar100_10]
           ,[textoAuxiliar100_2]
           ,[textoAuxiliar100_3]
           ,[textoAuxiliar100_4]
           ,[textoAuxiliar100_5]
           ,[textoAuxiliar100_6]
           ,[textoAuxiliar100_7]
           ,[textoAuxiliar100_8]
           ,[textoAuxiliar100_9]
           ,[textoAuxiliar250_1]
           ,[textoAuxiliar250_10]
           ,[textoAuxiliar250_11]
           ,[textoAuxiliar250_12]
           ,[textoAuxiliar250_13]
           ,[textoAuxiliar250_14]
           ,[textoAuxiliar250_15]
           ,[textoAuxiliar250_16]
           ,[textoAuxiliar250_17]
           ,[textoAuxiliar250_18]
           ,[textoAuxiliar250_19]
           ,[textoAuxiliar250_2]
           ,[textoAuxiliar250_20]
           ,[textoAuxiliar250_21]
           ,[textoAuxiliar250_22]
           ,[textoAuxiliar250_23]
           ,[textoAuxiliar250_24]
           ,[textoAuxiliar250_25]
           ,[textoAuxiliar250_3]
           ,[textoAuxiliar250_4]
           ,[textoAuxiliar250_5]
           ,[textoAuxiliar250_6]
           ,[textoAuxiliar250_7]
           ,[textoAuxiliar250_8]
           ,[textoAuxiliar250_9]
           ,[textoAuxiliar40_1]
           ,[textoAuxiliar40_10]
           ,[textoAuxiliar40_11]
           ,[textoAuxiliar40_12]
           ,[textoAuxiliar40_13]
           ,[textoAuxiliar40_14]
           ,[textoAuxiliar40_15]
           ,[textoAuxiliar40_16]
           ,[textoAuxiliar40_17]
           ,[textoAuxiliar40_18]
           ,[textoAuxiliar40_19]
           ,[textoAuxiliar40_2]
           ,[textoAuxiliar40_20]
           ,[textoAuxiliar40_3]
           ,[textoAuxiliar40_4]
           ,[textoAuxiliar40_5]
           ,[textoAuxiliar40_6]
           ,[textoAuxiliar40_7]
           ,[textoAuxiliar40_8]
           ,[textoAuxiliar40_9]
           ,[textoAuxiliar500_1]
           ,[textoAuxiliar500_2]
           ,[textoAuxiliar500_3]
           ,[textoAuxiliar500_4]
           ,[textoAuxiliar500_5]
           ,[textoLeyenda_1]
           ,[textoLeyenda_10]
           ,[textoLeyenda_11]
           ,[textoLeyenda_12]
           ,[textoLeyenda_13]
           ,[textoLeyenda_14]
           ,[textoLeyenda_15]
           ,[textoLeyenda_16]
           ,[textoLeyenda_17]
           ,[textoLeyenda_18]
           ,[textoLeyenda_19]
           ,[textoLeyenda_2]
           ,[textoLeyenda_20]
           ,[textoLeyenda_3]
           ,[textoLeyenda_4]
           ,[textoLeyenda_5]
           ,[textoLeyenda_6]
           ,[textoLeyenda_7]
           ,[textoLeyenda_8]
           ,[textoLeyenda_9]
           ,[tipoDocumentoAdquiriente]
           ,[tipoDocumentoReferenciaCorregi]
           ,[tipoDocumentoReferenciaPrincip]
           ,[tipoMoneda]
           ,[tipoOperacionFactura]
           ,[tipoReferenciaAdicional_1]
           ,[tipoReferenciaAdicional_2]
           ,[tipoReferenciaAdicional_3]
           ,[tipoReferenciaAdicional_4]
           ,[tipoReferenciaAdicional_5]
           ,[tipoReferencia_1]
           ,[tipoReferencia_2]
           ,[tipoReferencia_3]
           ,[tipoReferencia_4]
           ,[tipoReferencia_5]
           ,[totalBonificacion]
           ,[totalDescuentos]
           ,[totalDetraccion]
           ,[totalDocumentoAnticipo]
           ,[totalIgv]
           ,[totalIsc]
           ,[totalOtrosCargos]
           ,[totalOtrosTributos]
           ,[totalPercepcion]
           ,[totalRetencion]
           ,[totalValorVentaNetoOpExonerada]
           ,[totalValorVentaNetoOpGratuitas]
           ,[totalValorVentaNetoOpGravadas]
           ,[totalValorVentaNetoOpNoGravada]
           ,[totalVenta]
           ,[totalVentaConPercepcion]
           ,[ubigeoEmisor]
           ,[urbanizacion]
           ,[valorReferencialDetraccion]
           ,[bl_reintentoJob]
           ,[BL_SOURCEFILE]
           ,[visualizado])
     VALUES
           (<numeroDocumentoEmisor, varchar(20),>
           ,<serieNumero, varchar(13),>
           ,<tipoDocumento, varchar(2),>
           ,<tipoDocumentoEmisor, varchar(1),>
           ,<bl_estadoRegistro, varchar(1),>
           ,<bl_reintento, int,>
           ,<bl_origen, varchar(1),>
           ,<bl_hasFileResponse, int,>
           ,<baseImponiblePercepcion, varchar(15),>
           ,<codigoAuxiliar100_1, varchar(4),>
           ,<codigoAuxiliar100_10, varchar(4),>
           ,<codigoAuxiliar100_2, varchar(4),>
           ,<codigoAuxiliar100_3, varchar(4),>
           ,<codigoAuxiliar100_4, varchar(4),>
           ,<codigoAuxiliar100_5, varchar(4),>
           ,<codigoAuxiliar100_6, varchar(4),>
           ,<codigoAuxiliar100_7, varchar(4),>
           ,<codigoAuxiliar100_8, varchar(4),>
           ,<codigoAuxiliar100_9, varchar(4),>
           ,<codigoAuxiliar250_1, varchar(4),>
           ,<codigoAuxiliar250_10, varchar(4),>
           ,<codigoAuxiliar250_11, varchar(4),>
           ,<codigoAuxiliar250_12, varchar(4),>
           ,<codigoAuxiliar250_13, varchar(4),>
           ,<codigoAuxiliar250_14, varchar(4),>
           ,<codigoAuxiliar250_15, varchar(4),>
           ,<codigoAuxiliar250_16, varchar(4),>
           ,<codigoAuxiliar250_17, varchar(4),>
           ,<codigoAuxiliar250_18, varchar(4),>
           ,<codigoAuxiliar250_19, varchar(4),>
           ,<codigoAuxiliar250_2, varchar(4),>
           ,<codigoAuxiliar250_20, varchar(4),>
           ,<codigoAuxiliar250_21, varchar(4),>
           ,<codigoAuxiliar250_22, varchar(4),>
           ,<codigoAuxiliar250_23, varchar(4),>
           ,<codigoAuxiliar250_24, varchar(4),>
           ,<codigoAuxiliar250_25, varchar(4),>
           ,<codigoAuxiliar250_3, varchar(4),>
           ,<codigoAuxiliar250_4, varchar(4),>
           ,<codigoAuxiliar250_5, varchar(4),>
           ,<codigoAuxiliar250_6, varchar(4),>
           ,<codigoAuxiliar250_7, varchar(4),>
           ,<codigoAuxiliar250_8, varchar(4),>
           ,<codigoAuxiliar250_9, varchar(4),>
           ,<codigoAuxiliar40_1, varchar(4),>
           ,<codigoAuxiliar40_10, varchar(4),>
           ,<codigoAuxiliar40_11, varchar(4),>
           ,<codigoAuxiliar40_12, varchar(4),>
           ,<codigoAuxiliar40_13, varchar(4),>
           ,<codigoAuxiliar40_14, varchar(4),>
           ,<codigoAuxiliar40_15, varchar(4),>
           ,<codigoAuxiliar40_16, varchar(4),>
           ,<codigoAuxiliar40_17, varchar(4),>
           ,<codigoAuxiliar40_18, varchar(4),>
           ,<codigoAuxiliar40_19, varchar(4),>
           ,<codigoAuxiliar40_2, varchar(4),>
           ,<codigoAuxiliar40_20, varchar(4),>
           ,<codigoAuxiliar40_3, varchar(4),>
           ,<codigoAuxiliar40_4, varchar(4),>
           ,<codigoAuxiliar40_5, varchar(4),>
           ,<codigoAuxiliar40_6, varchar(4),>
           ,<codigoAuxiliar40_7, varchar(4),>
           ,<codigoAuxiliar40_8, varchar(4),>
           ,<codigoAuxiliar40_9, varchar(4),>
           ,<codigoAuxiliar500_1, varchar(4),>
           ,<codigoAuxiliar500_2, varchar(4),>
           ,<codigoAuxiliar500_3, varchar(4),>
           ,<codigoAuxiliar500_4, varchar(4),>
           ,<codigoAuxiliar500_5, varchar(4),>
           ,<codigoLeyenda_1, varchar(4),>
           ,<codigoLeyenda_10, varchar(4),>
           ,<codigoLeyenda_11, varchar(4),>
           ,<codigoLeyenda_12, varchar(4),>
           ,<codigoLeyenda_13, varchar(4),>
           ,<codigoLeyenda_14, varchar(4),>
           ,<codigoLeyenda_15, varchar(4),>
           ,<codigoLeyenda_16, varchar(4),>
           ,<codigoLeyenda_17, varchar(4),>
           ,<codigoLeyenda_18, varchar(4),>
           ,<codigoLeyenda_19, varchar(4),>
           ,<codigoLeyenda_2, varchar(4),>
           ,<codigoLeyenda_20, varchar(4),>
           ,<codigoLeyenda_3, varchar(4),>
           ,<codigoLeyenda_4, varchar(4),>
           ,<codigoLeyenda_5, varchar(4),>
           ,<codigoLeyenda_6, varchar(4),>
           ,<codigoLeyenda_7, varchar(4),>
           ,<codigoLeyenda_8, varchar(4),>
           ,<codigoLeyenda_9, varchar(4),>
           ,<codigoSerieNumeroAfectado, varchar(2),>
           ,<correoAdquiriente, varchar(100),>
           ,<correoEmisor, varchar(100),>
           ,<departamentoEmisor, varchar(30),>
           ,<descripcionDetraccion, varchar(100),>
           ,<descuentosGlobales, varchar(15),>
           ,<direccionEmisor, varchar(100),>
           ,<distritoEmisor, varchar(30),>
           ,<fechaEmision, varchar(10),>
           ,<inHabilitado, varchar(1),>
           ,<lugarDestino, varchar(100),>
           ,<motivoDocumento, varchar(500),>
           ,<nombreComercialEmisor, varchar(100),>
           ,<numeroDocumentoAdquiriente, varchar(15),>
           ,<numeroDocumentoRefeAdicional_1, varchar(30),>
           ,<numeroDocumentoRefeAdicional_2, varchar(30),>
           ,<numeroDocumentoRefeAdicional_3, varchar(30),>
           ,<numeroDocumentoRefeAdicional_4, varchar(30),>
           ,<numeroDocumentoRefeAdicional_5, varchar(30),>
           ,<numeroDocumentoReferenciaCorre, varchar(13),>
           ,<numeroDocumentoReferenciaPrinc, varchar(13),>
           ,<numeroDocumentoReferencia_1, varchar(30),>
           ,<numeroDocumentoReferencia_2, varchar(30),>
           ,<numeroDocumentoReferencia_3, varchar(30),>
           ,<numeroDocumentoReferencia_4, varchar(30),>
           ,<numeroDocumentoReferencia_5, varchar(30),>
           ,<paisEmisor, varchar(2),>
           ,<porcentajeDetraccion, varchar(15),>
           ,<porcentajePercepcion, varchar(15),>
           ,<porcentajeRetencion, varchar(15),>
           ,<provinciaEmisor, varchar(30),>
           ,<razonSocialAdquiriente, varchar(100),>
           ,<razonSocialEmisor, varchar(100),>
           ,<serieNumeroAfectado, varchar(13),>
           ,<subTotal, varchar(15),>
           ,<textoAdicionalLeyenda_1, varchar(200),>
           ,<textoAdicionalLeyenda_10, varchar(200),>
           ,<textoAdicionalLeyenda_11, varchar(200),>
           ,<textoAdicionalLeyenda_12, varchar(200),>
           ,<textoAdicionalLeyenda_13, varchar(200),>
           ,<textoAdicionalLeyenda_14, varchar(200),>
           ,<textoAdicionalLeyenda_15, varchar(200),>
           ,<textoAdicionalLeyenda_16, varchar(200),>
           ,<textoAdicionalLeyenda_17, varchar(200),>
           ,<textoAdicionalLeyenda_18, varchar(200),>
           ,<textoAdicionalLeyenda_19, varchar(200),>
           ,<textoAdicionalLeyenda_2, varchar(200),>
           ,<textoAdicionalLeyenda_20, varchar(200),>
           ,<textoAdicionalLeyenda_3, varchar(200),>
           ,<textoAdicionalLeyenda_4, varchar(200),>
           ,<textoAdicionalLeyenda_5, varchar(200),>
           ,<textoAdicionalLeyenda_6, varchar(200),>
           ,<textoAdicionalLeyenda_7, varchar(200),>
           ,<textoAdicionalLeyenda_8, varchar(200),>
           ,<textoAdicionalLeyenda_9, varchar(200),>
           ,<textoAuxiliar100_1, varchar(100),>
           ,<textoAuxiliar100_10, varchar(100),>
           ,<textoAuxiliar100_2, varchar(100),>
           ,<textoAuxiliar100_3, varchar(100),>
           ,<textoAuxiliar100_4, varchar(100),>
           ,<textoAuxiliar100_5, varchar(100),>
           ,<textoAuxiliar100_6, varchar(100),>
           ,<textoAuxiliar100_7, varchar(100),>
           ,<textoAuxiliar100_8, varchar(100),>
           ,<textoAuxiliar100_9, varchar(100),>
           ,<textoAuxiliar250_1, varchar(250),>
           ,<textoAuxiliar250_10, varchar(250),>
           ,<textoAuxiliar250_11, varchar(250),>
           ,<textoAuxiliar250_12, varchar(250),>
           ,<textoAuxiliar250_13, varchar(250),>
           ,<textoAuxiliar250_14, varchar(250),>
           ,<textoAuxiliar250_15, varchar(250),>
           ,<textoAuxiliar250_16, varchar(250),>
           ,<textoAuxiliar250_17, varchar(250),>
           ,<textoAuxiliar250_18, varchar(250),>
           ,<textoAuxiliar250_19, varchar(250),>
           ,<textoAuxiliar250_2, varchar(250),>
           ,<textoAuxiliar250_20, varchar(250),>
           ,<textoAuxiliar250_21, varchar(250),>
           ,<textoAuxiliar250_22, varchar(250),>
           ,<textoAuxiliar250_23, varchar(250),>
           ,<textoAuxiliar250_24, varchar(250),>
           ,<textoAuxiliar250_25, varchar(250),>
           ,<textoAuxiliar250_3, varchar(250),>
           ,<textoAuxiliar250_4, varchar(250),>
           ,<textoAuxiliar250_5, varchar(250),>
           ,<textoAuxiliar250_6, varchar(250),>
           ,<textoAuxiliar250_7, varchar(250),>
           ,<textoAuxiliar250_8, varchar(250),>
           ,<textoAuxiliar250_9, varchar(250),>
           ,<textoAuxiliar40_1, varchar(40),>
           ,<textoAuxiliar40_10, varchar(40),>
           ,<textoAuxiliar40_11, varchar(40),>
           ,<textoAuxiliar40_12, varchar(40),>
           ,<textoAuxiliar40_13, varchar(40),>
           ,<textoAuxiliar40_14, varchar(40),>
           ,<textoAuxiliar40_15, varchar(40),>
           ,<textoAuxiliar40_16, varchar(40),>
           ,<textoAuxiliar40_17, varchar(40),>
           ,<textoAuxiliar40_18, varchar(40),>
           ,<textoAuxiliar40_19, varchar(40),>
           ,<textoAuxiliar40_2, varchar(40),>
           ,<textoAuxiliar40_20, varchar(40),>
           ,<textoAuxiliar40_3, varchar(40),>
           ,<textoAuxiliar40_4, varchar(40),>
           ,<textoAuxiliar40_5, varchar(40),>
           ,<textoAuxiliar40_6, varchar(40),>
           ,<textoAuxiliar40_7, varchar(40),>
           ,<textoAuxiliar40_8, varchar(40),>
           ,<textoAuxiliar40_9, varchar(40),>
           ,<textoAuxiliar500_1, varchar(500),>
           ,<textoAuxiliar500_2, varchar(500),>
           ,<textoAuxiliar500_3, varchar(500),>
           ,<textoAuxiliar500_4, varchar(500),>
           ,<textoAuxiliar500_5, varchar(500),>
           ,<textoLeyenda_1, varchar(200),>
           ,<textoLeyenda_10, varchar(200),>
           ,<textoLeyenda_11, varchar(200),>
           ,<textoLeyenda_12, varchar(200),>
           ,<textoLeyenda_13, varchar(200),>
           ,<textoLeyenda_14, varchar(200),>
           ,<textoLeyenda_15, varchar(200),>
           ,<textoLeyenda_16, varchar(200),>
           ,<textoLeyenda_17, varchar(200),>
           ,<textoLeyenda_18, varchar(200),>
           ,<textoLeyenda_19, varchar(200),>
           ,<textoLeyenda_2, varchar(200),>
           ,<textoLeyenda_20, varchar(200),>
           ,<textoLeyenda_3, varchar(200),>
           ,<textoLeyenda_4, varchar(200),>
           ,<textoLeyenda_5, varchar(200),>
           ,<textoLeyenda_6, varchar(200),>
           ,<textoLeyenda_7, varchar(200),>
           ,<textoLeyenda_8, varchar(200),>
           ,<textoLeyenda_9, varchar(200),>
           ,<tipoDocumentoAdquiriente, varchar(1),>
           ,<tipoDocumentoReferenciaCorregi, varchar(2),>
           ,<tipoDocumentoReferenciaPrincip, varchar(2),>
           ,<tipoMoneda, varchar(3),>
           ,<tipoOperacionFactura, varchar(2),>
           ,<tipoReferenciaAdicional_1, varchar(2),>
           ,<tipoReferenciaAdicional_2, varchar(2),>
           ,<tipoReferenciaAdicional_3, varchar(2),>
           ,<tipoReferenciaAdicional_4, varchar(2),>
           ,<tipoReferenciaAdicional_5, varchar(2),>
           ,<tipoReferencia_1, varchar(2),>
           ,<tipoReferencia_2, varchar(2),>
           ,<tipoReferencia_3, varchar(2),>
           ,<tipoReferencia_4, varchar(2),>
           ,<tipoReferencia_5, varchar(2),>
           ,<totalBonificacion, varchar(15),>
           ,<totalDescuentos, varchar(15),>
           ,<totalDetraccion, varchar(15),>
           ,<totalDocumentoAnticipo, varchar(18),>
           ,<totalIgv, varchar(15),>
           ,<totalIsc, varchar(15),>
           ,<totalOtrosCargos, varchar(15),>
           ,<totalOtrosTributos, varchar(15),>
           ,<totalPercepcion, varchar(15),>
           ,<totalRetencion, varchar(15),>
           ,<totalValorVentaNetoOpExonerada, varchar(15),>
           ,<totalValorVentaNetoOpGratuitas, varchar(18),>
           ,<totalValorVentaNetoOpGravadas, varchar(15),>
           ,<totalValorVentaNetoOpNoGravada, varchar(15),>
           ,<totalVenta, varchar(15),>
           ,<totalVentaConPercepcion, varchar(15),>
           ,<ubigeoEmisor, varchar(6),>
           ,<urbanizacion, varchar(25),>
           ,<valorReferencialDetraccion, varchar(15),>
           ,<bl_reintentoJob, int,>
           ,<BL_SOURCEFILE, varchar(40),>
           ,<visualizado, int,>)
GO

SELECT [numeroDocumentoEmisor]
      ,[serieNumero]
      ,[tipoDocumento]
      ,[tipoDocumentoEmisor]
      ,[bl_estadoRegistro]
      ,[bl_reintento]
      ,[bl_origen]
      ,[bl_hasFileResponse]
      ,[baseImponiblePercepcion]
      ,[codigoAuxiliar100_1]
      ,[codigoAuxiliar100_10]
      ,[codigoAuxiliar100_2]
      ,[codigoAuxiliar100_3]
      ,[codigoAuxiliar100_4]
      ,[codigoAuxiliar100_5]
      ,[codigoAuxiliar100_6]
      ,[codigoAuxiliar100_7]
      ,[codigoAuxiliar100_8]
      ,[codigoAuxiliar100_9]
      ,[codigoAuxiliar250_1]
      ,[codigoAuxiliar250_10]
      ,[codigoAuxiliar250_11]
      ,[codigoAuxiliar250_12]
      ,[codigoAuxiliar250_13]
      ,[codigoAuxiliar250_14]
      ,[codigoAuxiliar250_15]
      ,[codigoAuxiliar250_16]
      ,[codigoAuxiliar250_17]
      ,[codigoAuxiliar250_18]
      ,[codigoAuxiliar250_19]
      ,[codigoAuxiliar250_2]
      ,[codigoAuxiliar250_20]
      ,[codigoAuxiliar250_21]
      ,[codigoAuxiliar250_22]
      ,[codigoAuxiliar250_23]
      ,[codigoAuxiliar250_24]
      ,[codigoAuxiliar250_25]
      ,[codigoAuxiliar250_3]
      ,[codigoAuxiliar250_4]
      ,[codigoAuxiliar250_5]
      ,[codigoAuxiliar250_6]
      ,[codigoAuxiliar250_7]
      ,[codigoAuxiliar250_8]
      ,[codigoAuxiliar250_9]
      ,[codigoAuxiliar40_1]
      ,[codigoAuxiliar40_10]
      ,[codigoAuxiliar40_11]
      ,[codigoAuxiliar40_12]
      ,[codigoAuxiliar40_13]
      ,[codigoAuxiliar40_14]
      ,[codigoAuxiliar40_15]
      ,[codigoAuxiliar40_16]
      ,[codigoAuxiliar40_17]
      ,[codigoAuxiliar40_18]
      ,[codigoAuxiliar40_19]
      ,[codigoAuxiliar40_2]
      ,[codigoAuxiliar40_20]
      ,[codigoAuxiliar40_3]
      ,[codigoAuxiliar40_4]
      ,[codigoAuxiliar40_5]
      ,[codigoAuxiliar40_6]
      ,[codigoAuxiliar40_7]
      ,[codigoAuxiliar40_8]
      ,[codigoAuxiliar40_9]
      ,[codigoAuxiliar500_1]
      ,[codigoAuxiliar500_2]
      ,[codigoAuxiliar500_3]
      ,[codigoAuxiliar500_4]
      ,[codigoAuxiliar500_5]
      ,[codigoLeyenda_1]
      ,[codigoLeyenda_10]
      ,[codigoLeyenda_11]
      ,[codigoLeyenda_12]
      ,[codigoLeyenda_13]
      ,[codigoLeyenda_14]
      ,[codigoLeyenda_15]
      ,[codigoLeyenda_16]
      ,[codigoLeyenda_17]
      ,[codigoLeyenda_18]
      ,[codigoLeyenda_19]
      ,[codigoLeyenda_2]
      ,[codigoLeyenda_20]
      ,[codigoLeyenda_3]
      ,[codigoLeyenda_4]
      ,[codigoLeyenda_5]
      ,[codigoLeyenda_6]
      ,[codigoLeyenda_7]
      ,[codigoLeyenda_8]
      ,[codigoLeyenda_9]
      ,[codigoSerieNumeroAfectado]
      ,[correoAdquiriente]
      ,[correoEmisor]
      ,[departamentoEmisor]
      ,[descripcionDetraccion]
      ,[descuentosGlobales]
      ,[direccionEmisor]
      ,[distritoEmisor]
      ,[fechaEmision]
      ,[inHabilitado]
      ,[lugarDestino]
      ,[motivoDocumento]
      ,[nombreComercialEmisor]
      ,[numeroDocumentoAdquiriente]
      ,[numeroDocumentoRefeAdicional_1]
      ,[numeroDocumentoRefeAdicional_2]
      ,[numeroDocumentoRefeAdicional_3]
      ,[numeroDocumentoRefeAdicional_4]
      ,[numeroDocumentoRefeAdicional_5]
      ,[numeroDocumentoReferenciaCorre]
      ,[numeroDocumentoReferenciaPrinc]
      ,[numeroDocumentoReferencia_1]
      ,[numeroDocumentoReferencia_2]
      ,[numeroDocumentoReferencia_3]
      ,[numeroDocumentoReferencia_4]
      ,[numeroDocumentoReferencia_5]
      ,[paisEmisor]
      ,[porcentajeDetraccion]
      ,[porcentajePercepcion]
      ,[porcentajeRetencion]
      ,[provinciaEmisor]
      ,[razonSocialAdquiriente]
      ,[razonSocialEmisor]
      ,[serieNumeroAfectado]
      ,[subTotal]
      ,[textoAdicionalLeyenda_1]
      ,[textoAdicionalLeyenda_10]
      ,[textoAdicionalLeyenda_11]
      ,[textoAdicionalLeyenda_12]
      ,[textoAdicionalLeyenda_13]
      ,[textoAdicionalLeyenda_14]
      ,[textoAdicionalLeyenda_15]
      ,[textoAdicionalLeyenda_16]
      ,[textoAdicionalLeyenda_17]
      ,[textoAdicionalLeyenda_18]
      ,[textoAdicionalLeyenda_19]
      ,[textoAdicionalLeyenda_2]
      ,[textoAdicionalLeyenda_20]
      ,[textoAdicionalLeyenda_3]
      ,[textoAdicionalLeyenda_4]
      ,[textoAdicionalLeyenda_5]
      ,[textoAdicionalLeyenda_6]
      ,[textoAdicionalLeyenda_7]
      ,[textoAdicionalLeyenda_8]
      ,[textoAdicionalLeyenda_9]
      ,[textoAuxiliar100_1]
      ,[textoAuxiliar100_10]
      ,[textoAuxiliar100_2]
      ,[textoAuxiliar100_3]
      ,[textoAuxiliar100_4]
      ,[textoAuxiliar100_5]
      ,[textoAuxiliar100_6]
      ,[textoAuxiliar100_7]
      ,[textoAuxiliar100_8]
      ,[textoAuxiliar100_9]
      ,[textoAuxiliar250_1]
      ,[textoAuxiliar250_10]
      ,[textoAuxiliar250_11]
      ,[textoAuxiliar250_12]
      ,[textoAuxiliar250_13]
      ,[textoAuxiliar250_14]
      ,[textoAuxiliar250_15]
      ,[textoAuxiliar250_16]
      ,[textoAuxiliar250_17]
      ,[textoAuxiliar250_18]
      ,[textoAuxiliar250_19]
      ,[textoAuxiliar250_2]
      ,[textoAuxiliar250_20]
      ,[textoAuxiliar250_21]
      ,[textoAuxiliar250_22]
      ,[textoAuxiliar250_23]
      ,[textoAuxiliar250_24]
      ,[textoAuxiliar250_25]
      ,[textoAuxiliar250_3]
      ,[textoAuxiliar250_4]
      ,[textoAuxiliar250_5]
      ,[textoAuxiliar250_6]
      ,[textoAuxiliar250_7]
      ,[textoAuxiliar250_8]
      ,[textoAuxiliar250_9]
      ,[textoAuxiliar40_1]
      ,[textoAuxiliar40_10]
      ,[textoAuxiliar40_11]
      ,[textoAuxiliar40_12]
      ,[textoAuxiliar40_13]
      ,[textoAuxiliar40_14]
      ,[textoAuxiliar40_15]
      ,[textoAuxiliar40_16]
      ,[textoAuxiliar40_17]
      ,[textoAuxiliar40_18]
      ,[textoAuxiliar40_19]
      ,[textoAuxiliar40_2]
      ,[textoAuxiliar40_20]
      ,[textoAuxiliar40_3]
      ,[textoAuxiliar40_4]
      ,[textoAuxiliar40_5]
      ,[textoAuxiliar40_6]
      ,[textoAuxiliar40_7]
      ,[textoAuxiliar40_8]
      ,[textoAuxiliar40_9]
      ,[textoAuxiliar500_1]
      ,[textoAuxiliar500_2]
      ,[textoAuxiliar500_3]
      ,[textoAuxiliar500_4]
      ,[textoAuxiliar500_5]
      ,[textoLeyenda_1]
      ,[textoLeyenda_10]
      ,[textoLeyenda_11]
      ,[textoLeyenda_12]
      ,[textoLeyenda_13]
      ,[textoLeyenda_14]
      ,[textoLeyenda_15]
      ,[textoLeyenda_16]
      ,[textoLeyenda_17]
      ,[textoLeyenda_18]
      ,[textoLeyenda_19]
      ,[textoLeyenda_2]
      ,[textoLeyenda_20]
      ,[textoLeyenda_3]
      ,[textoLeyenda_4]
      ,[textoLeyenda_5]
      ,[textoLeyenda_6]
      ,[textoLeyenda_7]
      ,[textoLeyenda_8]
      ,[textoLeyenda_9]
      ,[tipoDocumentoAdquiriente]
      ,[tipoDocumentoReferenciaCorregi]
      ,[tipoDocumentoReferenciaPrincip]
      ,[tipoMoneda]
      ,[tipoOperacionFactura]
      ,[tipoReferenciaAdicional_1]
      ,[tipoReferenciaAdicional_2]
      ,[tipoReferenciaAdicional_3]
      ,[tipoReferenciaAdicional_4]
      ,[tipoReferenciaAdicional_5]
      ,[tipoReferencia_1]
      ,[tipoReferencia_2]
      ,[tipoReferencia_3]
      ,[tipoReferencia_4]
      ,[tipoReferencia_5]
      ,[totalBonificacion]
      ,[totalDescuentos]
      ,[totalDetraccion]
      ,[totalDocumentoAnticipo]
      ,[totalIgv]
      ,[totalIsc]
      ,[totalOtrosCargos]
      ,[totalOtrosTributos]
      ,[totalPercepcion]
      ,[totalRetencion]
      ,[totalValorVentaNetoOpExonerada]
      ,[totalValorVentaNetoOpGratuitas]
      ,[totalValorVentaNetoOpGravadas]
      ,[totalValorVentaNetoOpNoGravada]
      ,[totalVenta]
      ,[totalVentaConPercepcion]
      ,[ubigeoEmisor]
      ,[urbanizacion]
      ,[valorReferencialDetraccion]
      ,[bl_reintentoJob]
      ,[BL_SOURCEFILE]
      ,[visualizado]
  FROM [dbo].[SPE_EINVOICEHEADER]
GO




	