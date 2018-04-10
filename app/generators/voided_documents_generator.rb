require_relative 'document_generator'


class VoidedDocumentsGenerator < DocumentGenerator

  def initialize()
    super("voided documents", 0)
  end

  def generate

    lcanio= $lg_fecha.year
    lcmes = $lg_fecha.mon
    lcdia = $lg_fecha.mday
    


    @voidedlast = Voided.find(1)

    correlative_number = @voidedlast.numero.to_s

    issue_date = Date.new(lcanio,lcmes,lcdia)
    
    lcNumeroFactura=$lg_serial_id2

    voided_documents_data = {reference_date: Date.new(lcanio,lcmes,lcdia), issue_date: issue_date, id: SUNAT::VoidedDocuments.generate_id(issue_date, correlative_number), correlative_number: correlative_number,
                         lines:[{line_id: "1", document_type_code: "01", document_serial_id: "FF01", document_number_id: lcNumeroFactura  , void_reason: "Error en datos consignados" }]}

    voided_document = SUNAT::VoidedDocuments.new(voided_documents_data)

    generate_documents(voided_document)
    voided_document
    
    File::open("voided_document.xml", "w") { |file| file.write(voided_document.to_xml) }
    voided_document.to_pdf
    
  end

  def generate_documents(document)
    if document.valid?
      ticket = document.deliver!
      document_status = ticket.get_status
      while document_status.in_process?
        document_status = ticket.get_status
      end
      if document_status.error?
        file_name = "voided_document_error.zip"
        document_status.save_content_to(file_name)
        $aviso =" Documento de anulacion NO fue generado con exito , ver archivo #{file_name} para conocer el motivo. "
      end
    else
      raise "Invalid voided document: #{document.errors}"
    end
  end
  
  def generate2

    lcanio= $lg_fecha.year
    lcmes = $lg_fecha.mon
    lcdia = $lg_fecha.mday    


    @voidedlast = Voided.find(1)

    correlative_number = @voidedlast.numero.to_s

    issue_date = Date.new(lcanio,lcmes,lcdia)
    
    lcNumeroFactura =  $lg_serial_id2
    puts lcNumeroFactura
    
    if $lcTd  == 1

    voided_documents_data = {reference_date: Date.new(lcanio,lcmes,lcdia), issue_date: issue_date, id: SUNAT::VoidedDocuments.generate_id(issue_date, correlative_number), correlative_number: correlative_number,
                         lines:[{line_id: "1", document_type_code: "07", document_serial_id: "FF01", document_number_id: lcNumeroFactura  , void_reason: "Error en datos consignados" }]}
    else
    voided_documents_data = {reference_date: Date.new(lcanio,lcmes,lcdia), issue_date: issue_date, id: SUNAT::VoidedDocuments.generate_id(issue_date, correlative_number), correlative_number: correlative_number,
                         lines:[{line_id: "1", document_type_code: "06", document_serial_id: "FF01", document_number_id: lcNumeroFactura  , void_reason: "Error en datos consignados" }]}
    
    end 
  

    voided_document = SUNAT::VoidedDocuments.new(voided_documents_data)

    generate_documents(voided_document)
    $lcValido = "0"
    if voided_document.valid?
      voided_document
      File::open("voided_document.xml", "w") { |file| file.write(voided_document.to_xml) }
      voided_document.to_pdf
      $lcValido = "1"
     else
      $lcValido = "0"
      raise "Invalid voided document: #{voided_document.errors}"
    end 
  end


  
end