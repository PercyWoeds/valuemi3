
# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model

    DEFAULT_CUSTOMIZATION_ID = "1.0"
    DATE_FORMAT = "%Y-%m-%d"

    property :id,                         String # Usually: serial + correlative number
    property :issue_date,                 Date
    property :customization_id,           String
    property :company_name,               String
    property :document_type_name,         String
    property :accounting_supplier_party,  AccountingSupplierParty
    property :additional_properties,      [AdditionalProperty]
    property :additional_monetary_totals, [AdditionalMonetaryTotal]
    property :pdf_path,                   String
    property :global_discount_percent,    Float


    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end


    def not_implemented_exception
      "Implement in child document"
    end

    def initialize(*args)
      super(*args)
      #self.issue_date ||= Date.today
      self.issue_date ||= $lg_fecha 

      self.additional_properties ||= []
      self.additional_monetary_totals ||= []
    end

    def accounting_supplier_party
      get_attribute(:accounting_supplier_party) || AccountingSupplierParty.new(SUNAT::SUPPLIER.as_hash)
    end

    def file_name
      raise not_implemented_exception
    end

    def operation_list
      raise not_implemented_exception
    end

    def operation
      raise not_implemented_exception
    end

    def build_pdf_header(pdf)
     if self.accounting_supplier_party.logo_path.present?
        pdf.image "#{self.accounting_supplier_party.logo_path}", :width => 200
        pdf.move_down 2
      end
# 
      pdf.move_down 10


                                                                                
      pdf.bounding_box([345, 755], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C #{self.accounting_supplier_party.account_id}", :align => :center
          pdf.text "#{self.document_type_name.upcase}", :align => :center
          pdf.text "#{self.id}", :align => :center,
                                 :style => :bold
          pdf.text "Rectifica: #{self.billing_reference.invoice_document_reference.id}", :align => :center, :size => 8 if self.try(:billing_reference).present?
        end
      end
      pdf.move_down 5
      pdf
    end

    def build_pdf_header_extension(pdf)
      raise not_implemented_exception
    end

    def build_pdf_body(pdf)
      raise not_implemented_exception
    end


    def build_pdf_footer(pdf)


      puts "documento id "
      puts $lcDocumentIdFactura

  
 if $lcDocumentIdFactura == 1

      pdf.bounding_box([0, 225 ], :width => 535  ,height: 225 ) do

      pdf.stroke_bounds
      pdf.stroke_horizontal_rule

      row = []
       table_content = []  
         pdf.text "  "
         pdf.text "  " + $lcFormapagoMayus ,:font_style=> :bold

         row = []
         table_content = []
        row <<{:content =>"CUOTAS",:rowspan => 2,:border_width => 0}

         row << "Nro.Cuotas  "
         row << "Fecha de
          Vencimiento "
         row << "Tipo de
          Moneda "
         row << "Monto Neto a pagar"

         row <<{:content =>" ",:rowspan => 2,:border_width => 0}

        table_content << row


         if $lcMonedaValor  == "PEN"
            @moneda_valor = "SOL"
         else
            @moneda_valor = "DOLARES AMERICANOS"
         end

         row = []
         row << "01"
         row << $lg_fecha2.strftime("%d/%m/%Y")       
         row << @moneda_valor   
         @totalvalor = $lnTotalFactura.round(2) - $lcDetraccionImporte.round(2) - $lcRetencionImporte.round(2)
         row << @totalvalor        

         table_content << row
          row = []
          row <<{:content =>" ",:colspan => 5,:border_width => 0}

          table_content << row


          puts "dias pago +++++++++++++ "
          puts $lcDiasPago


          if $lcDiasPago !=  0

            result = pdf.table table_content, {:position => :center,
                                              :width => pdf.bounds.width * 0.70
                                              } do
                                                columns([0]).align=:center
                                                columns([1]).align=:center
                                                columns([2]).align=:center
                                                columns([3]).align=:center
                                                columns([3]).align=:center

                                                columns([0]).width = 50
                                                columns([3]).width = 80
                                              end

              pdf.stroke_horizontal_rule

           end

          table_content = []
          row = []

            if $lcDetraccionImporte > 0

                      table_content = ([
                      [{:content =>"DETRACCION EN MONEDA :  " + @moneda_valor,:colspan => 5 }],
                      ["% Detraccion " ,"Codigo " ,"Monto Detraccion: ", "Nro.Cuenta en el BN.","Moneda:"],

                      [ $lcDetraccionPercent.to_s ,$lcDetraccionCodigo ,$lcDetraccionImporte,$lcDetraccionCuenta ,"Sol"]
                      ])

                   pdf.table(table_content  ,{
                       :position => :center,
                       :width => pdf.bounds.width
                     })do
                       columns([0,1,2,3,4]).font_style = :bold
                        columns([0,1,2,3,4,]).align = :center

                     end

             end 


           image_path = open("https://chart.googleapis.com/chart?chs=90x90&cht=qr&chl=#{$lcCodigoBarra}&choe=UTF-8")

          pdf.table([[ "   ",{:image => image_path,:position => :center}  , " Representación impresa de la FACTURA ELECTRÓNICA, visita www.nubefact.com/20522012336
Autorizado mediante Resolución de Intendencia No.034-005-0005315"]],:cell_style => { :border_width => 0 } )


      end
    else 
        pdf.bounding_box([0, 125 ], :width => 535  ,height: 125 ) do

      pdf.stroke_bounds
      pdf.stroke_horizontal_rule

           image_path = open("https://chart.googleapis.com/chart?chs=90x90&cht=qr&chl=#{$lcCodigoBarra}&choe=UTF-8")

          pdf.table([[ "   ",{:image => image_path,:position => :center}  , "


         Representación impresa de la FACTURA ELECTRÓNICA, visita www.nubefact.com/20522012336
Autorizado mediante Resolución de Intendencia No.034-005-0005315"]],:cell_style => { :border_width => 0 } )

       end 

    end

      pdf

      

  

    end

    def build_pdf(path=false)

      Prawn::Document.generate(path || self.pdf_path || "app/pdf_output/#{file_name}.pdf" ,:bottom_margin=> 0.5) do |pdf|
      
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        
        build_pdf_footer(pdf)


        $lcFileName =path || self.pdf_path || "app/pdf_output/#{file_name}.pdf"
        $lcFileNameIni =file_name
        $lcFilezip =path || self.pdf_path || "/#{file_name}.zip"
        
      end
    end

    def to_pdf(path=false)
      build_pdf(path)
    end

    def customization_id
      self['customization_id'] ||= DEFAULT_CUSTOMIZATION_ID
    end

    def add_additional_property(options)
      id = options[:id]
      name = options[:name]
      value = options[:value]

      self.additional_properties << AdditionalProperty.new.tap do |property|
        property.id = id        if id
        property.name = name    if name
        property.value = value  if value
      end
    end

    def get_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] == value)
          results.push ap
        end
      end
      results
    end

    def get_additional_property_by_id(id)
      get_additional_properties_by_property(:id, id)[0]
    end

    def remove_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] != value)
          results.push ap
        end
      end
      self.additional_properties = results
      results
    end

    def modify_additional_property_by_id(ap)
      remove_additional_properties_by_property(:id, ap[:id])
      add_additional_property ap
    end

    def add_additional_monetary_total(options)
      id = options[:id]
      payable_amount = options[:payable_amount]
      reference_amount = options[:reference_amount]
      total_amount = options[:total_amount]
      percent = options[:percent]

      self.additional_monetary_totals << AdditionalMonetaryTotal.new.tap do |amt|
        amt.id = id                             if id
        amt.payable_amount = payable_amount     if payable_amount
        amt.reference_amount = reference_amount if reference_amount
        amt.total_amount = total_amount         if total_amount
        amt.percent = percent                   if percent
      end
    end

    def get_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] == value)
          results.push amt
        end
      end
      results
    end

    def get_monetary_total_by_id(id)
      get_monetary_totals_by_property(:id, id)[0]
    end

    def remove_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] != value)
          results.push amt
        end
      end
      self.additional_monetary_totals = results
      results
    end

    def modify_monetary_total(amt)
      remove_monetary_totals_by_property(:id, amt[:id])
      add_additional_monetary_total amt
    end

    # The signature here is for two reasons:
    #   1. easy call of the global SUNAT::SIGNATURE
    #   2. possible dependency injection of a signature in a test via stubs
    #
    attr_accessor :signature

    def signature
      @signature ||= SUNAT::SIGNATURE
    end

    def supplier
      @supplier ||= SUNAT::SUPPLIER
    end

    def to_xml
      # We create a decorator responsible to build the xml in top
      # of this document
      xml_document = XMLDocument.new(self)

       # Pass control over to the xml builder
      res = xml_document.build_xml do |xml|
        build_xml(xml)
      end

      # We pass a decorator to xml_signer, to allow it to use some generators
      # of xml_document
      xml_signer = XMLSigner.new(xml_document)
      xml_signer.sign(res.to_xml)
    end

    def build_xml(xml)
      raise "This method must be overriden!"
    end

    def to_zip
      @zip ||= Delivery::Chef.new(file_name + ".xml", to_xml).prepare
    end

    def format_date(date)
      date.strftime(DATE_FORMAT)
    end

    def sender
      @sender ||= SUNAT::Delivery::Sender.new
    end
  end
end
