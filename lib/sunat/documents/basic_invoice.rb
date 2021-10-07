module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
require 'active_support/number_helper'

  class BasicInvoice < Document

    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    DEFAULT_CURRENCY_CODE = 'PEN'

    include HasTaxTotals

    property :invoice_type_code,               String
    property :document_currency_code,          String
    property :customer,                        AccountingCustomerParty
    property :lines,                           [InvoiceLine]
    property :tax_totals,                      [TaxTotal]
    property :legal_monetary_total,            PaymentAmount
    property :despatch_document_references,    [ReferralGuideline] # Spanish: Guías de remisión

    validate :id_valid?
    validates :id, presence: true
    validates :document_currency_code, existence: true, currency_code: true
    validates :invoice_type_code, tax_document_type_code: true
    validates :customer, presence: true
    validates :legal_monetary_total, existence: true

    def initialize(*args)
      self.lines ||= []
      self.invoice_type_code ||= self.class::DOCUMENT_TYPE_CODE
      self.tax_totals ||= []
      self.despatch_document_references ||= []
      self.document_type_name ||= "Factura Electronica"
      self.customer ||= AccountingCustomerParty.new({
        account_id: '-',
        additional_account_id: '-'
      })

      super(*args)
    end

    def document_currency_code
   
      
      currency = get_attribute(:document_currency_code)
      if currency
        currency
      elsif legal_monetary_total
        legal_monetary_total.currency
      else
        DEFAULT_CURRENCY_CODE
        
      end
    end

    def id_valid?
      valid = (self.class::ID_FORMAT =~ self.id) == 0
      if !valid
        errors.add(:id, "doesn't match regexp #{self.class::ID_FORMAT}")
      end
    end

    def file_name
      document_type_code = self.class::DOCUMENT_TYPE_CODE
      "#{accounting_supplier_party.account_id}-#{document_type_code}-#{id}"
    end

    def operation
      :send_bill
    end

    def total_tax_totals
      total = PaymentAmount.new(value:0, currency: document_currency_code)
      tax_totals.each {|tax_total| total = total + tax_total.tax_amount}
      total
    end

    def add_line(&block)
      line = InvoiceLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

    def build_pdf_body(pdf)
      
      
       pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
          :bold   => "app/assets/fonts/OpenSans-Bold.ttf",
        } )
      
       pdf.font "Open Sans",:size => 6

      max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold
          columns([1]).width = 300


        end

        pdf.move_down 5

      end

      headers = []
      table_content = []

      InvoiceLine::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFFF"
        cell.align = :center 
        headers << cell
      end


      table_content << headers

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                  
                                          columns([0]).align=:center
                                          columns([1]).align=:center
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:center 
                                          columns([5]).align=:center  
                                          
                                           columns([0]).width = 30
                                           columns([1]).width = 30
                                           
                                           columns([2]).width = 30
                                           columns([3]).width = 330
                                         
                                           columns([4]).width = 60
                                           columns([5]).width = 60                                    
                                        end

       table_content = []


       if $lcServicio == "true"
        row =[]
        row << ""
        row << ""
        row << ""
        row << $lcServiciotxt
        row << ""
        row << ""
        table_content<< row

      end 
      


      lines.each do |line|
        table_content << line.build_pdf_table_row(pdf)
      end


      puts "ancho tabla "
      puts pdf.bounds.width
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                        rows([0]).align=:center
                                          columns([0]).align=:center
                                          columns([1]).align=:left 
                                          columns([2]).align=:right
                                          columns([3]).align=:left 
                                          columns([4]).align=:right 
                                          columns([5]).align=:right 
                                          
                                          columns([0]).width = 30
                                           columns([1]).width = 30
                                           
                                           columns([2]).width = 30
                                           columns([3]).width = 330
                                         
                                           columns([4]).width = 60
                                           columns([5]).width = 60                                     
                                        end

      pdf.move_down 5

 
      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width / 3
      } do
        columns([0]).font_style = :bold
        columns([1]).align = :right
        columns([0]).width = 100
      end

      pdf.move_down 2

      pdf.table invoice_summary2, {
        :position => :right,
        :cell_style => {:border_width => 0 },
        :width => pdf.bounds.width
      } do
        columns([0]).font_style = :bold
        columns([1]).align = :left 

        columns([0]).width = 25

        
      end
 

      pdf.move_down 2
      
      pdf

    end

    def build_xml(xml)
      xml['cbc'].IssueDate format_date(self.issue_date)
    end

    def deliver!
      sender.submit_file(file_name, to_zip)
    end

    private

   def client_data_headers
      client_headers = [["Señor(es)   :", customer.party.party_legal_entity.registration_name]]
      client_headers << ["Dirección :",$lcDirCli]
      client_headers << [customer.type_as_text, customer.account_id]
      client_headers << ["Guia  :",$lcGuiaRemision]
      
      
      if $lcServicio =="true"

       client_headers << ["Local Comercial :",$lcLocal]
     else 
      client_headers << [" "," "]

      end 

      client_headers
    end

    def invoice_headers
      
      
      invoice_headers = [["Fecha de emisión:", issue_date.strftime("%d/%m/%Y") ]]
      invoice_headers << ["Fecha Vencimiento :",  $lg_fecha2.strftime("%d/%m/%Y") ]
      
      invoice_headers << ["Moneda :", Currency.new(document_currency_code).singular_name.upcase]
      invoice_headers << ["Forma de pago :", $lcFormapagoCorto ]
     

      invoice_headers
    end

    def invoice_summary

      monedasimbolo = Currency.new(document_currency_code).singular_name.upcase
      puts "moneda "
      puts monedasimbolo 

      invoice_summary = []

      if monedasimbolo.strip == "SOL"

          monetary_totals = [{label: "Operaciones gravadas S/", catalog_index: 0},
           {label: "Operaciones inafectas S/", catalog_index: 1},
           {label: "Operaciones exoneradas S/"  , catalog_index: 2},
           {label: "Operaciones gratuitas S/", catalog_index: 3},
           {label: "Sub total S/", catalog_index: 4},
           {label: "Total descuentos S/", catalog_index: 9}
          ]
           monetary_totals.each do |monetary_total|
        value = get_monetary_total_by_id(SUNAT::ANNEX::CATALOG_14[monetary_total[:catalog_index]])
        if value.present?
          invoice_summary << [monetary_total[:label], ActiveSupport::NumberHelper::number_to_delimited(value.payable_amount,delimiter:",",separator:".").to_s]
       
        end
      end



      tax_totals.each do |tax_total|
        invoice_summary << ["IGV S/",ActiveSupport::NumberHelper::number_to_delimited(tax_total.tax_amount,delimiter:",",separator:".").to_s]
      end

      invoice_summary << ["Total S/", ActiveSupport::NumberHelper::number_to_delimited(legal_monetary_total,delimiter:",",separator:".").to_s]

      
      else
        monetary_totals = [{label: "Operaciones gravadas USD", catalog_index: 0},
           {label: "Operaciones inafectas USD", catalog_index: 1},
           {label: "Operaciones exoneradas USD"  , catalog_index: 2},
           {label: "Operaciones gratuitas USD", catalog_index: 3},
           {label: "Sub total USD", catalog_index: 4},
           {label: "Total descuentos USD", catalog_index: 9}
          ]

           monetary_totals.each do |monetary_total|
        value = get_monetary_total_by_id(SUNAT::ANNEX::CATALOG_14[monetary_total[:catalog_index]])
        if value.present?
          invoice_summary << [monetary_total[:label], ActiveSupport::NumberHelper::number_to_delimited(value.payable_amount,delimiter:",",separator:".").to_s]
        
        end
      end



      tax_totals.each do |tax_total|
        invoice_summary << ["IGV USD",ActiveSupport::NumberHelper::number_to_delimited(tax_total.tax_amount,delimiter:",",separator:".").to_s]
      end

      invoice_summary << ["Total USD", ActiveSupport::NumberHelper::number_to_delimited(legal_monetary_total,delimiter:",",separator:".").to_s]  
      end 

     
    end

    def  invoice_summary2

      invoice_summary2 = []

      if get_additional_property_by_id(SUNAT::ANNEX::CATALOG_15[0])
        total = get_additional_property_by_id(SUNAT::ANNEX::CATALOG_15[0]).value
      else
        total = legal_monetary_total.textify.upcase
      end

      invoice_summary2 << ["SON: ", ActiveSupport::NumberHelper::number_to_delimited(total,delimiter:",",separator:".")]
      invoice_summary2

     
    end

    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end

  end
end
