require_relative 'document_generator'

class InvoiceGenerator < DocumentGenerator
  attr_reader :items 
   

  #$lcAutorizacion1=$lcAutorizacion <<' Datos Adicionales GUIA DE REMISION : '<<$lcGuiaRemision

  def initialize(group, group_case, items, serie)
    super(group, group_case)
    @items = items
    @serie = serie
  end 

  def with_igv(pdf=false)
    invoice = document_class.new(data(@items))
    generate_documents(invoice, pdf)
    invoice
  end

      
  
  
  protected

  def document_class
    SUNAT::Invoice
  end

  
   
  #$lcid= "#{@serie}-#{"%06d" % @@document_serial_id }"
        
  protected
      def customer
       {legal_name:$lcLegalName , ruc: $lcRuc}
      end

  private
   

  def data(items = 0, currency = 'PEN')
    invoice_data = {id: "#{@serie}-#{"%06d" %  $lg_serial_id}", customer: customer, 
    tax_totals: [{amount: {value: items*$lcIgv, currency: currency}, type: :igv}], legal_monetary_total: {value: $lcTotal * items, currency: currency}, 
    additional_monetary_totals: [{id: "1001", payable_amount: {value: $lcVVenta * items, currency: currency}}]}

      invoice_data[:lines] = []
      if items > 0
        invoice_data[:lines] = (1..items).map do |item|
          {id: item.to_s, quantity: $lcCantidad, line_extension_amount: {value: $lcTotal, currency: currency}, pricing_reference: {alternative_condition_price: {price_amount: {value: $lcPrecioCigv, currency: currency}}}, 
           price: {value: $lcPrecioSIgv, currency: currency}, tax_totals: [{amount: {value: $lcTotal, currency: currency}, type: :igv}], 
           item: {id: item.to_s, description: $lcDescrip }}
        end

      end
      invoice_data
    end
end 


