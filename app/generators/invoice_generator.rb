require_relative 'document_generator'

class InvoiceGenerator < DocumentGenerator
  attr_reader :items    

  #$lcAutorizacion1=$lcAutorizacion <<' Datos Adicionales GUIA DE REMISION : '<<$lcGuiaRemision

  def initialize(group, group_case, items, serie,numero)
    super(group, group_case)
    @items = items
    @serie = serie
    @numero = numero 
    
  end 

  def with_igv(pdf=false)
    invoice = document_class.new(data(@items))
    generate_documents(invoice, pdf)
    invoice
  end

  def with_igv2(pdf=false)
    invoice = document_class.new(data(@items))
    generate_documents2(invoice, pdf)
    invoice
  end
  
  def with_igv3(pdf=false)
    invoice = document_class.new(data(@items))
    generate_documents3(invoice, pdf)
    invoice
  end

  def exempt(pdf=false)
    invoice_data = data
    invoice_data[:lines] = (1..@items).map do |item|
      {id: item.to_s, quantity: 1.0, line_extension_amount: 10000, pricing_reference: 10000, price: 10000,
       item: {id: item.to_s, description: "Item #{item}"}, tax_totals: [{amount: 0, type: :igv, code: "20"}]}
    end
    invoice_data[:additional_monetary_totals] << {id: "1003", payable_amount: @items*10000}
    invoice = document_class.new(invoice_data)
    invoice.legal_monetary_total.value = invoice.legal_monetary_total.value + @items*10000
    generate_documents(invoice, pdf)
    invoice
  end
  
  def free(pdf=false)
    invoice_data = data
    invoice_data[:lines] = (1..@items).map do |item|
      {id: @items.to_s, quantity: 1.0, line_extension_amount: 0, pricing_reference: {amount: 10000, free: true}, price: 0,
       item: {id: @items.to_s, description: "Item #{@items}"}, tax_totals: [{amount: 0, type: :igv, code: "31"}]}
    end
    invoice_data[:additional_monetary_totals] << {id: "1004", payable_amount: @items*10000}
    invoice_data[:additional_properties] = [{id: "1002", value: "TRANSFERENCIA GRATUITA"}]
    invoice = document_class.new(invoice_data)
    generate_documents(invoice, pdf)
    invoice
  end

  def with_discount(pdf=false)
    invoice = document_class.new(data(@items))
    
    taxable_total = invoice.get_monetary_total_by_id("1001")
    discount = (taxable_total.payable_amount.value * 0.05).round
    taxable_total.payable_amount = taxable_total.payable_amount.value - discount
    new_tax_totals = {amount: (taxable_total.payable_amount.to_f * 18).round, type: :igv}

    invoice.allowance_total_amount = discount
    invoice.modify_monetary_total(taxable_total)
    invoice.add_additional_monetary_total({id: "2005", payable_amount: discount})
    invoice.tax_totals = [new_tax_totals]
    invoice.legal_monetary_total = invoice.total_tax_totals + taxable_total.payable_amount

    generate_documents(invoice, pdf)
    invoice
  end

  def with_isc(pdf=false)
    invoice_data = data(@items - 1)
    invoice_data[:lines] << {id: @items.to_s, quantity: 1.0, line_extension_amount: 10000, pricing_reference: 13500, price: 10000, 
                             item: {id: @items.to_s, description: "Item #{@items}"}, tax_totals: [{amount: 1800, type: :igv}, {amount: 1700, type: :isc}]}
    invoice = document_class.new(invoice_data)
    
    taxable_total = invoice.get_monetary_total_by_id("1001")
    taxable_total.payable_amount = taxable_total.payable_amount.value + 10000
    invoice.modify_monetary_total(taxable_total)

    invoice.legal_monetary_total.value = invoice.legal_monetary_total.value + 13500
    
    new_tax_totals = [{amount: invoice.total_tax_totals + SUNAT::PaymentAmount.new(1800), type: :igv}, {amount: 1700, type: :isc}]
    invoice.tax_totals = new_tax_totals

    generate_documents(invoice, pdf)
    invoice
  end

  def with_reception(pdf=false)
    invoice = document_class.new(data(@items))
    payable_amount = (invoice.legal_monetary_total.value * 0.02).round
    invoice.add_additional_monetary_total({id: "2001", reference_amount: invoice.legal_monetary_total, payable_amount: payable_amount, total_amount: invoice.legal_monetary_total.value + payable_amount})
    invoice.add_additional_property({id: "2000", value: "COMPROBANTE PERCEPCION"})
    generate_documents(invoice, pdf)
    invoice
  end

  def with_different_currency(pdf=false)
    invoice = document_class.new(data(@items, 'USD'))
    generate_documents(invoice, pdf)
    invoice
  end
  
  def with_different_currency2(pdf=false)
    
    invoice = document_class.new(data(@items, 'USD'))
    generate_documents2(invoice, pdf)
    invoice
  end
  
  protected

  def document_class
    SUNAT::Invoice
  end
  
   
  #$lcid= "#{@serie}-#{"%06d" % @@document_serial_id }"
        
  protected
      def customer
       {legal_name: $lcLegalName, ruc: $lcRuc}
      end

  private
   

  def data(items = 0, currency = 'PEN')
    
    @invoice = Factura.find(@numero)
    @invoiceitems = FacturaDetail.select(:product_id,:price_discount,"SUM(quantity) as cantidad","SUM(total) as total").where(factura_id: @numero).group(:product_id,:price_discount)
    
     $lg_fecha   = @invoice.fecha.to_date
         lcCode = @invoice.code.split("-")
         a = lcCode[0]
         b = lcCode[1]
         
        lcVVenta1      =  @invoice.subtotal * 100        
        lcVVenta_a       =  lcVVenta1.round(0)
            
        lcIgv1         =  @invoice.tax * 100
        lcIgv_a          =  lcIgv1.round(0)
        
        lcTotal1       =  @invoice.total * 100
        lcTotal_a        =  lcTotal1.round(0)
         
        
        @lg_serie_factura = a  
        @lg_serial_id   = b.to_i
        
        $lcRuc          = @invoice.customer.ruc
        
        $lcTd           = @invoice.document.descripshort
        
        $lcMail         = @invoice.customer.email
        $lcMail2        = ""
        $lcMail3        = ""
        
         legal_name_spaces = @invoice.customer.name.lstrip    
        
        if legal_name_spaces == nil
            $lcLegalName    = legal_name_spaces
        else
            $lcLegalName = @invoice.customer.name.lstrip    
        end
        $lcDirCli       = @invoice.customer.address1
        $lcDisCli       = @invoice.customer.address2
        $lcProv         = @invoice.customer.city
        $lcDep          = @invoice.customer.state
        $lcPlaca        =@invoice.description  
        
        puts @lg_serie_factura
        puts @lg_serial_id
        
        puts "***********"
        puts lcIgv_a 
        puts lcTotal_a 
        puts lcVVenta_a
        puts @invoice.subtotal 
        
        
    invoice_data = {id: "#{@lg_serie_factura}-#{"%06d" %  @lg_serial_id}", customer: customer, 
    tax_totals: [{amount: {value: items* lcIgv_a, currency: currency}, type: :igv}], legal_monetary_total: {value: lcTotal_a * items, currency: currency}, 
    additional_monetary_totals: [{id: "1001", payable_amount: {value: lcVVenta_a * items, currency: currency}}]}

      invoice_data[:lines] = []
      nro_item = 1 
      
        for detalle_item in @invoiceitems
        
        lcDes1   = detalle_item.product.name 
        lcCantidad     = detalle_item.cantidad  
        lcTotal0 = detalle_item.cantidad * detalle_item.price_discount
        lcTotal1 = lcTotal0 * 100
        lcTotal = lcTotal1.round(0)
        
        lcPrecio =  detalle_item.total   / detalle_item.cantidad   
        lcPrecioSIGV = lcPrecio /1.18
        lcValorVenta = detalle_item.total / 1.18
        lcTax = detalle_item.total - lcValorVenta
        
        lcPrecioCigv1  =  lcPrecio * 100
        
        lcPrecioCigv2   = lcPrecioCigv1.round(0).to_f
        lcPrecioCigv   =  lcPrecioCigv2.to_i 

        lcPrecioSigv1  =  lcPrecioSIGV * 100
        lcPrecioSigv2   = lcPrecioSigv1.round(0).to_f
        lcPrecioSIgv   =  lcPrecioSigv2.to_i 
        
        
              a   =  {id: nro_item.to_s, quantity: lcCantidad, line_extension_amount: {value: lcTotal, currency: currency}, 
           pricing_reference: {alternative_condition_price: {price_amount: {value: lcPrecioCigv, currency: currency}}}, 
           price: {value: lcPrecioSIgv, currency: currency}, tax_totals: [{amount: {value: lcTotal, currency: currency}, type: :igv}], 
           item: {id: nro_item.to_s, description: lcDes1}}
         
          invoice_data[:lines] << a 
          
          nro_item += 1 
         
      
      end 
      
      
      invoice_data
    end
end 


