class NubeFact::Document::Cuota 
  include NubeFact::Validator
  include NubeFact::Utils
  
  FIELDS = [
    "cuota",
    "fecha_pago",
    "importe",
    
  ]

  attr_accessor *FIELDS

  add_required_fields *%i(
    cuota
    fecha_pago
    importe
   )

  
  DEFAULT_DATA = {
               cuota: '0',
        fecha_pago: "",
        importe: 0
  }

  attr_accessor :invoice
  def initialize(invoice, data_hash)
    @invoice = invoice
    
    load_data_from_param data_hash

    puts "items cuota "

    puts data_hash

    validate!

   
  end
  
end