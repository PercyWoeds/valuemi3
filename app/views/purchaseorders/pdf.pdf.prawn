pdf.font "Helvetica"

pdf.text "Company: #{@purchaseorder.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "purchaseorder: #{@purchaseorder.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@purchaseorder.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@purchaseorder.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@purchaseorder.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@purchaseorder.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "supplier information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@purchaseorder.supplier.name}", :size => 13, :spacing => 4

if @purchaseorder.supplier.email and @purchaseorder.supplier.email != ""
  pdf.text "Email: #{@purchaseorder.supplier.email}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.account and @purchaseorder.supplier.account != ""
  pdf.text "Account: #{@purchaseorder.supplier.account}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.phone1 and @purchaseorder.supplier.phone1 != ""
  pdf.text "Phone 1: #{@purchaseorder.supplier.phone1}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.phone2 and @purchaseorder.supplier.phone2 != ""
  pdf.text "Phone 2: #{@purchaseorder.supplier.phone2}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.address1 and @purchaseorder.supplier.address1 != ""
  pdf.text "Address 1: #{@purchaseorder.supplier.address1}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.address2 and @purchaseorder.supplier.address2 != ""
  pdf.text "Address 2: #{@purchaseorder.supplier.address2}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.city and @purchaseorder.supplier.city != ""
  pdf.text "City: #{@purchaseorder.supplier.city}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.state and @purchaseorder.supplier.state != ""
  pdf.text "State: #{@purchaseorder.supplier.state}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.zip and @purchaseorder.supplier.zip != ""
  pdf.text "ZIP: #{@purchaseorder.supplier.zip}", :size => 13, :spacing => 4
end

if @purchaseorder.supplier.country and @purchaseorder.supplier.country != ""
  pdf.text "Country: #{@purchaseorder.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @purchaseorder.get_products()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@purchaseorder.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@purchaseorder.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@purchaseorder.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@purchaseorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]