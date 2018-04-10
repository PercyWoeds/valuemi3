class DocumentGenerator
  TYPES = {"SUNAT::Invoice"  => "01", "SUNAT::Receipt" => "03"}
    @@document_serial_id = $lg_serial_id
    
  attr_reader :group, :group_case

  def initialize(group, group_case)
    @group = group
    @group_case = group_case
  end


  def generate_documents(document, pdf=false)
    
    if document.valid?
     begin
     document.deliver!
      rescue Savon::SOAPFault => e
      puts "Error generating document for case #{group_case} in group #{group}: #{e}"      
      $aviso = "Error generating document for case #{group_case} in group #{group}: #{e}"
      end
      
      document.to_pdf if pdf
    else
     raise "Documento invalido para caso #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end

  def generate_documents2(document, pdf=false)

    if document.valid?
      begin
       document.to_pdf if pdf
       $aviso = "Documento impreso con exito..."      
      end 
     else
          
      raise "**** Documento invalido para caso #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end
  
  def generate_documents3(document, pdf=false)
    
    if document.valid?
     begin
      document.deliver!
      rescue Savon::SOAPFault => e
      puts "Error generating document for case #{group_case} in group #{group}: #{e}"      
      $aviso = ""

      end
      document.to_pdf if pdf
    else
     raise "Documento invalido para caso #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end

end
