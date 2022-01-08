* #########################################################
* #### INTEGRACIÓN FÁCIL ####
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++
* # ESTE CÓDIGO FUNCIONA PARA LA VERSIÓN ONLINE Y OFFLINE
* # Visita www.nubefact.com/integracion para más información
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++

* #########################################################
* #### FORMA DE TRABAJO ####
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++
* # PASO 1: Conseguir una RUTA y un TOKEN para trabajar con NUBEFACT (Regístrate o ingresa a tu cuenta en www.nubefact.com).
* # PASO 2: Generar un archivo en formato .JSON o .TXT con una estructura que se detalla en este documento.
* # PASO 3: Enviar el archivo generado a nuestra WEB SERVICE ONLINE u OFFLINE según corresponda usando la RUTA y el TOKEN.
* # PASO 4: Generamos el archivo XML y PDF (Según especificaciones de la SUNAT) y te devolveremos INSTANTÁNEAMENTE los datos del documento generado.
* # Para ver el documento generado ingresa a www.nubefact.com/login con tus datos de acceso, y luego a la opción "Ver Facturas, Boletas y Notas"
* # IMPORTANTE: Enviaremos el XML generado a la SUNAT y lo almacenaremos junto con el PDF, XML y CDR en la NUBE para que tu cliente pueda consultarlo en cualquier momento, si así lo desea.
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++

* VAMOS A USAR O CARGAR EL PROGRAMA json.prg QUE ESTA CARPETA O LA PUEDES DESCARGAR EN EL SIGUIENTE LINK: https://www.nubefact.com/downloads/example-code-json-vfpro

*PUBLIC AppDir
*AppDir = ADDBS(JUSTPATH(SYS(16,1)))
*SET DEFAULT TO (AppDir)  ADDITIVE

SET PROCEDURE TO JSON ADDITIVE


* #########################################################
* #### PASO 1: CONSEGUIR LA RUTA Y TOKEN ####
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++
* # CUENTA DEMO PARA HACER PRUEBAS
* # Puedes usar la siguiente cuenta para hacer pruebas:
* #  - LINK: https://demo.nubefact.com/login
* #  - USUARIO: demo@nubefact.com
* #  - PASSWORD: demo@nubefact.com
* # Una vez que ingreses a esta cuenta ve a la opción API (Integración) para ver la RUTA y el TOKEN los cuales son:
* #  - RUTA: https://demo.nubefact.com/api/v1/03989d1a-6c8c-4b71-b1cd-7d37001deaa0
* #  - TOKEN: d0a80b88cde446d092025465bdb4673e103a0d881ca6479ebbab10664dbc5677
* # También puedes crear una cuenta propia para hacer pruebas más precisas.
* #
* # CREAR UNA CUENTA PROPIA
* #  - Regístrate gratis en www.nubefact.com/register
* #  - Ir la opción API (Integración).
* # IMPORTANTE: Para que la opción API (Integración) de tu cuenta propia esté activada necesitas escribirnos a soporte@nubefact.com o llámanos al teléfono: 01 468 3535 (opción 2) o celular (WhatsApp) 955 598762.
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++

*# RUTA para enviar documentos
ruta = "https://api.nubefact.com/api/v1/f4782edc-ffdc-4c26-87f5-f6716f79ce44"

*# TOKEN para enviar documentos
token = "d0a80b88cde446d092025465bdb4673e103a0d881ca6479ebbab10664dbc5677"


*#########################################################
*#### PASO 2: GENERAR EL ARCHIVO PARA ENVIAR A NUBEFACT ####
*+++++++++++++++++++++++++++++++++++++++++++++++++++++++
*# - MANUAL para archivo JSON en el link: https://goo.gl/WHMmSb
*# - MANUAL para archivo TXT en el link: https://goo.gl/Lz7hAq
*+++++++++++++++++++++++++++++++++++++++++++++++++++++++

* CONSTRUIMOS EL JSON

TipoComprobante = 1
Serie = "FFF1"
Numero = 1
Fecha = "09-05-2017"

*# CAPTURAR VARIABLES DESDE UN FORMULARIO PODRÍA USAR LO SIGUIENTE:
* TipoComprobante=thisform.cbodocumento.DisplayValue
* Serie=thisform.cboserie.DisplayValue
* Nummero=thisform.txtnum.Value
* Fecha=thisform.cbodia.DisplayValue+"-"+thisform.cbomes.DisplayValue+"-"+thisform.cboan.DisplayValue
* thisform.Rpta.Caption =  Cliente+" "+TipoComprobante+" "+Serie+" "+Num+" "+Fecha


* CUIDADO! "TEXT TO" no funciona en versiones anteriores a VF8

TEXT TO json_para_envio NOSHOW TEXT PRETEXT 7
{
   "operacion": "generar_comprobante",
   "tipo_de_comprobante": "<<TipoComprobante>>",
   "serie": "<<Serie>>",
   "numero": "<<Numero>>",
   "sunat_transaction": 1,
   "cliente_tipo_de_documento": 6,
   "cliente_numero_de_documento": "20600695771",
   "cliente_denominacion": "NUBEFACT SA",
   "cliente_direccion": "CALLE LIBERTAD 116 MIRAFLORES - LIMA - PERU",
   "cliente_email": "",
   "cliente_email_1": "",
   "cliente_email_2": "",
   "fecha_de_emision": "<<Fecha>>",
   "fecha_de_vencimiento": "",
   "moneda": "1",
   "tipo_de_cambio": "",
   "porcentaje_de_igv": "18.00",
   "descuento_global": "",
   "total_descuento": "",
   "total_anticipo": "",
   "total_gravada": "600",
   "total_inafecta": "",
   "total_exonerada": "",
   "total_igv": "108",
   "total_gratuita": "",
   "total_otros_cargos": "",
   "total": "708",
   "percepcion_tipo": "",
   "percepcion_base_imponible": "",
   "total_percepcion": "",
   "total_incluido_percepcion": "",
   "detraccion": "false",
   "observaciones": "ÑoÑo, Ñaña, ?Ñ",
   "documento_que_se_modifica_tipo": "",
   "documento_que_se_modifica_serie": "",
   "documento_que_se_modifica_numero": "",
   "tipo_de_nota_de_credito": "",
   "tipo_de_nota_de_debito": "",
   "enviar_automaticamente_a_la_sunat": "true",
   "enviar_automaticamente_al_cliente": "false",
   "codigo_unico": "",
   "condiciones_de_pago": "",
   "medio_de_pago": "",
   "placa_vehiculo": "",
   "orden_compra_servicio": "",
   "tabla_personalizada_codigo": "",
   "formato_de_pdf": "",
   "items": [
         {
            "unidad_de_medida": "NIU",
            "codigo": "001",
            "descripcion": "DETALLE DEL PRODUCTO",
            "cantidad": "1",
            "valor_unitario": "500",
            "precio_unitario": "590",
            "descuento": "",
            "subtotal": "500",
            "tipo_de_igv": "1",
            "igv": "90",
            "total": "590",
            "anticipo_regularizacion": "false",
            "anticipo_documento_serie": "",
            "anticipo_documento_numero": ""
         }, {
            "unidad_de_medida": "ZZ",
            "codigo": "001",
            "descripcion": "DETALLE DEL SERVICIO",
            "cantidad": "5",
            "valor_unitario": "20",
            "precio_unitario": "23.60",
            "descuento": "",
            "subtotal": "100",
            "tipo_de_igv": "1",
            "igv": "18",
            "total": "118",
            "anticipo_regularizacion": "false",
            "anticipo_documento_serie": "",
            "anticipo_documento_numero": ""
         }
   ]
}
ENDTEXT

MESSAGEBOX(json_para_envio)
* #########################################################
* #### PASO 3: ENVIAR EL ARCHIVO A NUBEFACT ####
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++
* # SI ESTÁS TRABAJANDO CON ARCHIVO JSON
* # - Debes enviar en el HEADER de tu solicitud la siguiente lo siguiente:
* # Authorization = Token token="8d19d8c7c1f6402687720eab85cd57a54f5a7a3fa163476bbcf381ee2b5e0c69"
* # Content-Type = application/json
* # - Adjuntar en el CUERPO o BODY el archivo JSON o TXT
* # SI ESTÁS TRABAJANDO CON ARCHIVO TXT
* # - Debes enviar en el HEADER de tu solicitud la siguiente lo siguiente:
* # Authorization = Token token="8d19d8c7c1f6402687720eab85cd57a54f5a7a3fa163476bbcf381ee2b5e0c69"
* # Content-Type = text/plain
* # - Adjuntar en el CUERPO o BODY el archivo JSON o TXT
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++


post_connect = CreateObject("MSXML2.ServerXMLHTTP")

* Para algunas versiones de XMLHTTP, usar:
    post_connect = CreateObject("Microsoft.XMLHTTP")
    post_connect = CreateObject("MSXML2.XMLHTTP")

post_connect.Open("POST", ruta, .F.)
post_connect.setRequestHeader("Content-Type", "application/json")
post_connect.setRequestHeader("Authorization", "Token token=" + token)
post_connect.Send(json_para_envio)
json_respuesta = post_connect.responsetext



* #########################################################
* #### PASO 4: LEER RESPUESTA DE NUBEFACT ####
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++
* # Recibirás una respuesta de NUBEFACT inmediatamente lo cual se debe leer, verificando que no haya errores.
* # Debes guardar en la base de datos la respuesta que te devolveremos.
* # Escríbenos a soporte@nubefact.com o llámanos al teléfono: 01 468 3535 (opción 2) o celular (WhatsApp) 955 598762
* # Puedes imprimir el PDF que nosotros generamos como también generar tu propia representación impresa previa coordinación con nosotros.
* # La impresión del documento seguirá haciéndose desde tu sistema. Enviaremos el documento por email a tu cliente si así lo indicas en el archivo JSON o TXT.
* +++++++++++++++++++++++++++++++++++++++++++++++++++++++

leer_respuesta = json_decode(json_respuesta)
IF EMPTY(leer_respuesta.get('errors')) THEN
	MESSAGEBOX(leer_respuesta.get('tipo_de_comprobante'))
	MESSAGEBOX(leer_respuesta.get('serie'))
	MESSAGEBOX(leer_respuesta.get('numero'))
	MESSAGEBOX(leer_respuesta.get('enlace'))
	MESSAGEBOX(leer_respuesta.get('aceptada_por_sunat'))
	MESSAGEBOX(leer_respuesta.get('sunat_description'))
	MESSAGEBOX(leer_respuesta.get('sunat_note'))
	MESSAGEBOX(leer_respuesta.get('sunat_responsecode'))
	MESSAGEBOX(leer_respuesta.get('sunat_soap_error'))
	MESSAGEBOX(leer_respuesta.get('pdf_zip_base64'))
	MESSAGEBOX(leer_respuesta.get('xml_zip_base64'))
	MESSAGEBOX(leer_respuesta.get('cdr_zip_base64'))
	MESSAGEBOX(leer_respuesta.get('cadena_para_codigo_qr'))
	MESSAGEBOX(leer_respuesta.get('codigo_hash'))
ELSE
	MESSAGEBOX(leer_respuesta.get('errors'))
ENDIF