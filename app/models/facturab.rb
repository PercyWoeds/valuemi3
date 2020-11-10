
  
   #                             serie: @factura.code[0..3],
   #                            numero: @factura.code[5..8].to_i,
   #                 sunat_transaction: 1,
   #         cliente_tipo_de_documento: 0,
   #       cliente_numero_de_documento: @factura.customer.ruc,
   #              cliente_denominacion: @factura.customer.name,
   #                 cliente_direccion: @factura.customer.address1,
   #                     cliente_email: 'percywoeds@gmail.com',
   #                            moneda: 1,
   #                    tipo_de_cambio: 3.56,
   #                 porcentaje_de_igv: 18,
   #                    total_inafecta: 0.00,
   #                             total: @factura.total,
   # enviar_automaticamente_a_la_sunat: false,
   # enviar_automaticamente_al_cliente: false ,
   #                      codigo_unico: 'ABC',
   #                    formato_de_pdf: 'A4'
