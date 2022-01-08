PUBLIC miForm
miForm = CREATEOBJECT("FormularioPruebas")
miForm.SHOW
RETURN

DEFINE CLASS FormularioPruebas AS FORM
  ADD OBJECT ComboNombre AS ComboFiltroCerrado WITH ;
    LEFT = 10, TOP = 10, NAME = "ComboNombre", ;
    MAXLENGTH = 30, WIDTH = 340
  ADD OBJECT ComboNombre2 AS ComboFiltroAbierto WITH ;
    LEFT = 10, TOP = 50, NAME = "ComboNombre2", ;
    MAXLENGTH = 30, WIDTH = 340

  PROCEDURE ComboNombre.INIT
    DODEFAULT()
    THIS.SetAliasControl('Customer')
    THIS.SetCampoFiltro('Customer.Contact_Name')
  ENDPROC

  PROCEDURE INIT
    DODEFAULT()
    IF NOT USED ('Customer')
      USE (HOME(2) + "Tastrade\Data\Customer.dbf") IN 0 SHARED
    ENDIF
    THIS.ComboNombre.ROWSOURCE = 'Customer.Contact_Name'
    THIS.ComboNombre2.ROWSOURCE = 'Customer.Contact_Name'
  ENDPROC
ENDDEFINE

DEFINE CLASS ComboFiltroCerrado AS COMBOBOX
  INCREMENTALSEARCH = .F.
  ROWSOURCETYPE = 2
  SELECTEDITEMFORECOLOR = RGB(255,255,255)
  SELECTEDITEMBACKCOLOR = RGB(200,200,180)
  SELECTEDFORECOLOR = RGB(240,0,0)&&RGB(50,030,240)
  SELECTEDBACKCOLOR = RGB(200,200,180)
  STYLE = 0
  SORTED = .T.

  PROTECTED cadenaIntroducida AS STRING
  PROTECTED inicioSeleccion AS INTEGER
  PROTECTED finalSeleccion AS INTEGER

  PROTECTED aliasControl AS STRING
  PROTECTED campoFiltro AS STRING
  PROTECTED conFiltro AS Boolean

  PROCEDURE INIT
    DODEFAULT()
    THIS.cadenaIntroducida = ''
    THIS.aliasControl = ''
    THIS.campoFiltro = ''
    THIS.conFiltro = .F.
  ENDPROC

  PROCEDURE INTERACTIVECHANGE
    LOCAL codigoCaracter AS INTEGER
    LOCAL tamañoCadena AS INTEGER

    codigoCaracter = LASTKEY()
    IF codigoCaracter = 127
      tamañoCadena = LEN(THIS.cadenaIntroducida)
      IF tamañoCadena > 1
        THIS.cadenaIntroducida = LEFT(THIS.cadenaIntroducida, ;
          LEN(THIS.cadenaIntroducida)-1)
        THIS.BuscaRegistros(codigoCaracter)
      ELSE
        THIS.cadenaIntroducida = ''
        THIS.VALUE = ''
        THIS.SELSTART = 0
        THIS.SELLENGTH = 0
        THIS.QuitaFiltroRegistros()
      ENDIF
    ELSE
      IF BETWEEN(codigoCaracter,32,255)
        THIS.cadenaIntroducida = THIS.cadenaIntroducida + CHR(codigoCaracter)
        THIS.BuscaRegistros(codigoCaracter)
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE BuscaRegistros(_CodigoCaracter AS INTEGER)
    THIS.QuitaFiltroRegistros()
    FOR i = 1 TO THIS.LISTCOUNT
      IF UPPER(LEFT(THIS.LIST[i],LEN(THIS.cadenaIntroducida))) == ;
          ALLTRIM(UPPER(THIS.cadenaIntroducida))
        THIS.DISPLAYVALUE = THIS.LIST(i)
        THIS.SELSTART = ATC(UPPER(THIS.cadenaIntroducida), ;
          UPPER(THIS.LIST[i]), 1)-1
        THIS.SELLENGTH = LEN(THIS.cadenaIntroducida)
        THIS.FiltraRegistros()
        RETURN
      ENDIF
    ENDFOR
    FOR i = 1 TO THIS.LISTCOUNT
      IF UPPER(THIS.cadenaIntroducida) $ UPPER(THIS.LIST(i))
        THIS.DISPLAYVALUE = THIS.LIST(i)
        THIS.SELSTART = ATC(UPPER(THIS.cadenaIntroducida), ;
          UPPER(THIS.LIST[i]), 1)-1
        THIS.SELLENGTH = LEN(THIS.cadenaIntroducida)
        THIS.FiltraRegistros()
        RETURN
      ENDIF
    ENDFOR
    THIS.cadenaIntroducida= CHR(_CodigoCaracter)
    THIS.VALUE = CHR(_CodigoCaracter)
    THIS.DISPLAYVALUE = THIS.VALUE
    THIS.SELSTART = 0
    THIS.SELLENGTH = 1
  ENDPROC

  PROCEDURE QuitaFiltroRegistros()
    LOCAL aliasTabla
    IF THIS.conFiltro
      aliasTabla =THIS.aliasControl
      SET FILTER TO IN &aliasTabla
      THIS.REQUERY
    ENDIF
  ENDPROC

  HIDDEN PROCEDURE FiltraRegistros()
    LOCAL campo
    LOCAL aliasTabla
    PUBLIC textoSeleccionadoFiltro AS STRING
    IF THIS.conFiltro
      campo = THIS.campoFiltro
      aliasTabla = THIS.aliasControl
      textoSeleccionadoFiltro = THIS.SELTEXT
      SET FILTER TO (textoSeleccionadoFiltro $ &campo) IN &aliasTabla
      THIS.REQUERY
    ENDIF
  ENDPROC

  PROCEDURE SetAliasControl(_Alias AS STRING)
    THIS.aliasControl = _Alias
  ENDPROC

  PROCEDURE SetCampoFiltro(_Campo AS STRING)
    THIS.conFiltro = .T.
    THIS.campoFiltro = _Campo
  ENDPROC
ENDDEFINE

DEFINE CLASS ComboFiltroAbierto AS COMBOBOX
  INCREMENTALSEARCH = .F.
  ROWSOURCETYPE = 2
  SELECTEDITEMFORECOLOR = RGB(255,255,255)
  SELECTEDITEMBACKCOLOR = RGB(200,200,180)
  SELECTEDFORECOLOR = RGB(50,030,240)
  SELECTEDBACKCOLOR = RGB(200,200,180)
  STYLE = 0
  SORTED = .T.

  PROCEDURE INTERACTIVECHANGE
    LOCAL codigoCaracter AS INTEGER
    LOCAL valorDisplay AS STRING
    LOCAL valorNuevoDisplay AS STRING
    LOCAL lnUltimaSeleccion AS INTEGER
    LOCAL lnSeleccionados AS INTEGER
    codigoCaracter = LASTKEY()
    valorNuevoDisplay = ""
    lnUltimaSeleccion = 0
    lnSeleccionados = 0
    IF (codigoCaracter >= 32 AND codigoCaracter <= 126)
      valorDisplay = SUBSTR(THIS.DISPLAYVALUE,1,THIS.SELSTART-1)+(CHR(codigoCaracter))
      valorNuevoDisplay = THIS.DISPLAYVALUE
      FOR i = 1 TO THIS.LISTCOUNT
        IF UPPER(valorDisplay) $ UPPER(SUBSTR(THIS.LIST(i),1,LEN(valorDisplay)))
          THIS.DISPLAYVALUE = THIS.LIST(i)
          THIS.SELSTART = LEN(valorDisplay)
          IF LEN(ALLT(THIS.DISPLAYVALUE)) > LEN(valorDisplay)
            THIS.SELLENGTH = LEN(ALLT(THIS.DISPLAYVALUE))-LEN(valorDisplay)
          ELSE
            THIS.SELLENGTH = 0
          ENDIF
          valorNuevoDisplay = THIS.DISPLAYVALUE
          lnUltimaSeleccion = THIS.SELSTART
          lnSeleccionados = THIS.SELLENGTH
          RETURN
        ENDIF
      ENDFOR
      THIS.DISPLAYVALUE = valorNuevoDisplay
      THIS.SELSTART = IIF(lnUltimaSeleccion > 0, lnUltimaSeleccion, LEN(valorDisplay))
      THIS.SELLENGTH = lnSeleccionados
    ENDIF
  ENDPROC
ENDDEFINE