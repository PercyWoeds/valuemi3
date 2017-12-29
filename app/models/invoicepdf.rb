require "render_anywhere"
 
class Invoicepdf
  include RenderAnywhere
 
   def initialize(invoice)
     @payroll = invoice
  #   @payroll_details =PayrollDetail.where(payroll_id: invoice.id)
  #   puts "initialize"
   
   end
 
  def to_pdf
    kit = PDFKit.new(as_html, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/invoice.pdf")
  end
 
  def filename
    "Invoice #{invoice.id}.pdf"
  end
 
  private
 
    attr_reader :invoice
 
    def as_html
      @payroll = invoice
      @payroll_details =PayrollDetail.where(payroll_id: invoice.id)
  #   
      render template: "payrolls/pdf", layout: "invoice_pdf", locals: { invoice: invoice }
    end
end