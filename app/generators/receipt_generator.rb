require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator

  def customer
    
    if $lcTd != "F"
    {legal_name: "CLIENTE GENERICO", dni: "00000000"}
    else
    {legal_name: $lcLegalName , ruc:  $lcRuc0 }
    end 
    
  end

  def document_class
    SUNAT::Receipt
  end
end