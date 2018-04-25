pdf.page_size: [100, 2000]
pdf.margin: 10

pdf.font "Helvetica"


pdf.text "#{@invoice.company.name}", :size => 8,  :spacing => 4,:align => :center
pdf.text "RUC : #{@invoice.company.ruc}", :size => 8,  :spacing => 4 ,:align => :center
pdf.text "#{@invoice.company.address1}", :size => 8,  :spacing => 4
pdf.text "#{@invoice.company.address2}- #{@invoice.company.city}- #{@invoice.company.state} ", :size => 8,  :spacing => 4  ,:align => :center

if @invoice.document_id == 7
  pdf.text "#{@invoice.document.description} DE VENTA ELECTRONICA  " ,:align => :center,:style => :bold,:size => 8,  :spacing => 4
end 
if @invoice.document_id == 2
  pdf.text "#{@invoice.document.description} DE VENTA ELECTRONICA  " ,:align => :center,:style => :bold,:size => 8,  :spacing => 4
end 
pdf.text "#{@invoice.code}", :size => 8, :spacing => 4,:align => :center

pdf.text "CAJERO : #{@invoice.user.first_name} #{@invoice.user.last_name}", :size => 8,  :spacing => 4,:align => :left

for product in @invoice.get_products_2()
  pdf.text  "#{product.code} #{product.name} ", :size => 8, :spacing => 4
  pdf.text  "#{product.quantity} UND #{money(product.price)}  #{money(product.total)}", :size => 8, :spacing => 4
end

pdf.text "OP.INAFECTA      :    0.00 ", :size => 8, :style => :bold, :spacing => 4
pdf.text "OO.GRAVADA       : #{money(@invoice.subtotal)}", :size => 8, :style => :bold, :spacing => 4
pdf.text "I.G.V.:       S/.: #{money(@invoice.tax)}", :size => 8, :style => :bold, :spacing => 4
pdf.text "IMPORTE TOTAL S/.: #{money(@invoice.total)}", :size => 8, :style => :bold, :spacing => 4


pdf.text "CLIENTE: #{@invoice.customer.name}", :size => 13, :spacing => 4
pdf.text "Autorizado mediante Resolucion de Intendencia Nro.034-005-0005592/SUNAT del 22/06/2016"

pdf.image open("https://chart.googleapis.com/chart?chs=120x120&cht=qr&chl=#{$lcCodigoBarra}&choe=UTF-8")


pdf.draw_text "Company: #{@invoice.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]