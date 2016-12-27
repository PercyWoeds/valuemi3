

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@supplierpayment.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@supplierpayment.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@supplierpayment.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@supplierpayment.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@supplierpayment.supplier.name}", :size => 13, :spacing => 4

if @supplierpayment.supplier.email and @supplierpayment.supplier.email != ""
  pdf.text "Email: #{@supplierpayment.supplier.email}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.account and @supplierpayment.supplier.account != ""
  pdf.text "Account: #{@supplierpayment.supplier.account}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.phone1 and @supplierpayment.supplier.phone1 != ""
  pdf.text "Phone 1: #{@supplierpayment.supplier.phone1}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.phone2 and @supplierpayment.supplier.phone2 != ""
  pdf.text "Phone 2: #{@supplierpayment.supplier.phone2}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.address1 and @supplierpayment.supplier.address1 != ""
  pdf.text "Address 1: #{@supplierpayment.supplier.address1}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.address2 and @supplierpayment.supplier.address2 != ""
  pdf.text "Address 2: #{@supplierpayment.supplier.address2}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.city and @supplierpayment.supplier.city != ""
  pdf.text "City: #{@supplierpayment.supplier.city}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.state and @supplierpayment.supplier.state != ""
  pdf.text "State: #{@supplierpayment.supplier.state}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.zip and @supplierpayment.supplier.zip != ""
  pdf.text "ZIP: #{@supplierpayment.supplier.zip}", :size => 13, :spacing => 4
end

if @supplierpayment.supplier.country and @supplierpayment.supplier.country != ""
  pdf.text "Country: #{@supplierpayment.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @supplierpayment.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@supplierpayment.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@supplierpayment.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@supplierpayment.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@supplierpayment.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@supplierpayment.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    