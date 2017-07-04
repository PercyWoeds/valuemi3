

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@lgv.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@lgv.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@lgv.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@lgv.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@lgv.supplier.name}", :size => 13, :spacing => 4

if @lgv.supplier.email and @lgv.supplier.email != ""
  pdf.text "Email: #{@lgv.supplier.email}", :size => 13, :spacing => 4
end

if @lgv.supplier.account and @lgv.supplier.account != ""
  pdf.text "Account: #{@lgv.supplier.account}", :size => 13, :spacing => 4
end

if @lgv.supplier.phone1 and @lgv.supplier.phone1 != ""
  pdf.text "Phone 1: #{@lgv.supplier.phone1}", :size => 13, :spacing => 4
end

if @lgv.supplier.phone2 and @lgv.supplier.phone2 != ""
  pdf.text "Phone 2: #{@lgv.supplier.phone2}", :size => 13, :spacing => 4
end

if @lgv.supplier.address1 and @lgv.supplier.address1 != ""
  pdf.text "Address 1: #{@lgv.supplier.address1}", :size => 13, :spacing => 4
end

if @lgv.supplier.address2 and @lgv.supplier.address2 != ""
  pdf.text "Address 2: #{@lgv.supplier.address2}", :size => 13, :spacing => 4
end

if @lgv.supplier.city and @lgv.supplier.city != ""
  pdf.text "City: #{@lgv.supplier.city}", :size => 13, :spacing => 4
end

if @lgv.supplier.state and @lgv.supplier.state != ""
  pdf.text "State: #{@lgv.supplier.state}", :size => 13, :spacing => 4
end

if @lgv.supplier.zip and @lgv.supplier.zip != ""
  pdf.text "ZIP: #{@lgv.supplier.zip}", :size => 13, :spacing => 4
end

if @lgv.supplier.country and @lgv.supplier.country != ""
  pdf.text "Country: #{@lgv.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @lgv.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@lgv.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@lgv.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@lgv.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@lgv.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@lgv.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    