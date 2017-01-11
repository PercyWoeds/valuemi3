

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@customerpayment.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@customerpayment.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@customerpayment.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@customerpayment.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@customerpayment.supplier.name}", :size => 13, :spacing => 4

if @customerpayment.supplier.email and @customerpayment.supplier.email != ""
  pdf.text "Email: #{@customerpayment.supplier.email}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.account and @customerpayment.supplier.account != ""
  pdf.text "Account: #{@customerpayment.supplier.account}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.phone1 and @customerpayment.supplier.phone1 != ""
  pdf.text "Phone 1: #{@customerpayment.supplier.phone1}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.phone2 and @customerpayment.supplier.phone2 != ""
  pdf.text "Phone 2: #{@customerpayment.supplier.phone2}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.address1 and @customerpayment.supplier.address1 != ""
  pdf.text "Address 1: #{@customerpayment.supplier.address1}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.address2 and @customerpayment.supplier.address2 != ""
  pdf.text "Address 2: #{@customerpayment.supplier.address2}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.city and @customerpayment.supplier.city != ""
  pdf.text "City: #{@customerpayment.supplier.city}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.state and @customerpayment.supplier.state != ""
  pdf.text "State: #{@customerpayment.supplier.state}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.zip and @customerpayment.supplier.zip != ""
  pdf.text "ZIP: #{@customerpayment.supplier.zip}", :size => 13, :spacing => 4
end

if @customerpayment.supplier.country and @customerpayment.supplier.country != ""
  pdf.text "Country: #{@customerpayment.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @customerpayment.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@customerpayment.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@customerpayment.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@customerpayment.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@customerpayment.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@customerpayment.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    