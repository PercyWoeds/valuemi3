

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@viatico.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@viatico.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@viatico.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@viatico.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@viatico.supplier.name}", :size => 13, :spacing => 4

if @viatico.supplier.email and @viatico.supplier.email != ""
  pdf.text "Email: #{@viatico.supplier.email}", :size => 13, :spacing => 4
end

if @viatico.supplier.account and @viatico.supplier.account != ""
  pdf.text "Account: #{@viatico.supplier.account}", :size => 13, :spacing => 4
end

if @viatico.supplier.phone1 and @viatico.supplier.phone1 != ""
  pdf.text "Phone 1: #{@viatico.supplier.phone1}", :size => 13, :spacing => 4
end

if @viatico.supplier.phone2 and @viatico.supplier.phone2 != ""
  pdf.text "Phone 2: #{@viatico.supplier.phone2}", :size => 13, :spacing => 4
end

if @viatico.supplier.address1 and @viatico.supplier.address1 != ""
  pdf.text "Address 1: #{@viatico.supplier.address1}", :size => 13, :spacing => 4
end

if @viatico.supplier.address2 and @viatico.supplier.address2 != ""
  pdf.text "Address 2: #{@viatico.supplier.address2}", :size => 13, :spacing => 4
end

if @viatico.supplier.city and @viatico.supplier.city != ""
  pdf.text "City: #{@viatico.supplier.city}", :size => 13, :spacing => 4
end

if @viatico.supplier.state and @viatico.supplier.state != ""
  pdf.text "State: #{@viatico.supplier.state}", :size => 13, :spacing => 4
end

if @viatico.supplier.zip and @viatico.supplier.zip != ""
  pdf.text "ZIP: #{@viatico.supplier.zip}", :size => 13, :spacing => 4
end

if @viatico.supplier.country and @viatico.supplier.country != ""
  pdf.text "Country: #{@viatico.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @viatico.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@viatico.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@viatico.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@viatico.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@viatico.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@viatico.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    