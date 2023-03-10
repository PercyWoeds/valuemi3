class NubeFact::Document::Item2
  include NubeFact::Validator
  include NubeFact::Utils
  
  FIELDS = [
    "unidad_de_medida",
      # NIU = PRODUCTO
      # ZZ = SERVICIO
      # Puedes crear mas unidades en tu cuenta de NUBEFACT.
    "codigo",
    "descripcion",
    "cantidad",
    "valor_unitario",
      # sin IGV
    "precio_unitario",
      # con IGV
    "descuento",
    "subtotal",
      # VALOR_UNITARIO * CANTIDAD - DESCUENTO 
    "tipo_de_igv",
      # 1 = Gravado - Operación Onerosa
      # 2 = Gravado – Retiro por premio
      # 3 = Gravado – Retiro por donación
      # 4 = Gravado – Retiro
      # 5 = Gravado – Retiro por publicidad
      # 6 = Gravado – Bonificaciones
      # 7 = Gravado – Retiro por entrega a trabajadores
      # 8 = Exonerado - Operación Onerosa
      # 9 = Inafecto - Operación Onerosa
      # 10 = Inafecto – Retiro por Bonificación
      # 11 = Inafecto – Retiro
      # 12 = Inafecto – Retiro por Muestras Médicas
      # 13 = Inafecto - Retiro por Convenio Colectivo
      # 14 = Inafecto – Retiro por premio
      # 15 = Inafecto - Retiro por publicidad
      # 16 = Exportación
    "igv",
      # Total de IGV
    "total",
      # Total de la linea 
    "anticipo_regularizacion",
    "anticipo_documento_serie",
    "anticipo_documento_numero",
    'codigo_producto_sunat'
  ]
  attr_accessor *FIELDS

  add_required_fields *%i(
    unidad_de_medida
    descripcion
    cantidad
    valor_unitario
    tipo_de_igv
  )

 

  DEFAULT_DATA = {
               unidad_de_medida: 'ZZ',
        anticipo_regularizacion: false,
                      descuento: 0
  }

  attr_accessor :invoice
  def initialize(invoice, data_hash)
    @invoice = invoice
    
    load_data_from_param data_hash

    puts "items"

    puts data_hash

    validate!

   
  end

  def calculate_amounts
   
  
  end

  TYPES_SUBJECT_TO_IGV = [1, 2, 3, 4, 5, 6, 7]
  def should_add_igv?
    # Check description on FIELDS constant
    TYPES_SUBJECT_TO_IGV.include? tipo_de_igv
  end
  
end