pdf.font "Helvetica"
pdf.font "Helvetica"

pdf.text "Company: #{@purchase.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "purchase: #{@purchase.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@purchase.document}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@purchase.payable_amount)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@purchase.tax_amount)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@purchase.total_amount)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "supplier information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@purchase.supplier.name}", :size => 13, :spacing => 4

if @purchase.supplier.email and @purchase.supplier.email != ""
  pdf.text "Email: #{@purchase.supplier.email}", :size => 13, :spacing => 4
end


if @purchase.supplier.phone1 and @purchase.supplier.phone1 != ""
  pdf.text "Phone 1: #{@purchase.supplier.phone1}", :size => 13, :spacing => 4
end

if @purchase.supplier.phone2 and @purchase.supplier.phone2 != ""
  pdf.text "Phone 2: #{@purchase.supplier.phone2}", :size => 13, :spacing => 4
end

if @purchase.supplier.address1 and @purchase.supplier.address1 != ""
  pdf.text "Address 1: #{@purchase.supplier.address1}", :size => 13, :spacing => 4
end

if @purchase.supplier.address2 and @purchase.supplier.address2 != ""
  pdf.text "Address 2: #{@purchase.supplier.address2}", :size => 13, :spacing => 4
end

if @purchase.supplier.city and @purchase.supplier.city != ""
  pdf.text "City: #{@purchase.supplier.city}", :size => 13, :spacing => 4
end

if @purchase.supplier.state and @purchase.supplier.state != ""
  pdf.text "State: #{@purchase.supplier.state}", :size => 13, :spacing => 4
end

if @purchase.supplier.zip and @purchase.supplier.zip != ""
  pdf.text "ZIP: #{@purchase.supplier.zip}", :size => 13, :spacing => 4
end

if @purchase.supplier.country and @purchase.supplier.country != ""
  pdf.text "Country: #{@purchase.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @purchase.get_products()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@purchase.payable_amount)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@purchase.tax_amount)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@purchase.total_amount)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@purchase.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]