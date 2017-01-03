pdf.font "Helvetica"

pdf.text "Company: #{@invoice.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Factura: #{@invoice.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@invoice.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@invoice.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Igv: #{money(@invoice.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@invoice.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion Cliente ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Nombre: #{@invoice.customer.name}", :size => 13, :spacing => 4

if @invoice.customer.email and @invoice.customer.email != ""
  pdf.text "Email: #{@invoice.customer.email}", :size => 13, :spacing => 4
end

if @invoice.customer.account and @invoice.customer.account != ""
  pdf.text "Account: #{@invoice.customer.account}", :size => 13, :spacing => 4
end

if @invoice.customer.phone1 and @invoice.customer.phone1 != ""
  pdf.text "Phone 1: #{@invoice.customer.phone1}", :size => 13, :spacing => 4
end

if @invoice.customer.phone2 and @invoice.customer.phone2 != ""
  pdf.text "Phone 2: #{@invoice.customer.phone2}", :size => 13, :spacing => 4
end

if @invoice.customer.address1 and @invoice.customer.address1 != ""
  pdf.text "Address 1: #{@invoice.customer.address1}", :size => 13, :spacing => 4
end

if @invoice.customer.address2 and @invoice.customer.address2 != ""
  pdf.text "Address 2: #{@invoice.customer.address2}", :size => 13, :spacing => 4
end

if @invoice.customer.city and @invoice.customer.city != ""
  pdf.text "City: #{@invoice.customer.city}", :size => 13, :spacing => 4
end

if @invoice.customer.state and @invoice.customer.state != ""
  pdf.text "State: #{@invoice.customer.state}", :size => 13, :spacing => 4
end

if @invoice.customer.zip and @invoice.customer.zip != ""
  pdf.text "ZIP: #{@invoice.customer.zip}", :size => 13, :spacing => 4
end

if @invoice.customer.country and @invoice.customer.country != ""
  pdf.text "Country: #{@invoice.customer.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4


for product in @invoice.get_products()

  pdf.text  "#{product.name} "
  pdf.text  "Precio: #{money(product.price)} - Cantidad: #{product.quantity} - Dscto: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
  
end

pdf.text "Guias Transportista"

for guia in @invoice.get_guias()

  pdf.text "#{guia.code} "

  for guias in  @invoice.get_guias_remision(guia.id)
     pdf.text  "GR:" "#{guias.delivery.code}"
  end        

end

pdf.text "Guias Remision"
for guia in @invoice.get_guiasremision()
  pdf.text "#{guia.code} "
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@invoice.subtotal)}", :size => 13, :spacing => 4
pdf.text "Igv: #{money(@invoice.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@invoice.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@invoice.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]