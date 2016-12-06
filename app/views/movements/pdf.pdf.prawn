pdf.font "Helvetica"

pdf.text "Company: #{@movement.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "movement: #{@movement.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@movement.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@movement.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@movement.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@movement.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "supplier information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@movement.supplier.name}", :size => 13, :spacing => 4

if @movement.supplier.email and @movement.supplier.email != ""
  pdf.text "Email: #{@movement.supplier.email}", :size => 13, :spacing => 4
end

if @movement.supplier.account and @movement.supplier.account != ""
  pdf.text "Account: #{@movement.supplier.account}", :size => 13, :spacing => 4
end

if @movement.supplier.phone1 and @movement.supplier.phone1 != ""
  pdf.text "Phone 1: #{@movement.supplier.phone1}", :size => 13, :spacing => 4
end

if @movement.supplier.phone2 and @movement.supplier.phone2 != ""
  pdf.text "Phone 2: #{@movement.supplier.phone2}", :size => 13, :spacing => 4
end

if @movement.supplier.address1 and @movement.supplier.address1 != ""
  pdf.text "Address 1: #{@movement.supplier.address1}", :size => 13, :spacing => 4
end

if @movement.supplier.address2 and @movement.supplier.address2 != ""
  pdf.text "Address 2: #{@movement.supplier.address2}", :size => 13, :spacing => 4
end

if @movement.supplier.city and @movement.supplier.city != ""
  pdf.text "City: #{@movement.supplier.city}", :size => 13, :spacing => 4
end

if @movement.supplier.state and @movement.supplier.state != ""
  pdf.text "State: #{@movement.supplier.state}", :size => 13, :spacing => 4
end

if @movement.supplier.zip and @movement.supplier.zip != ""
  pdf.text "ZIP: #{@movement.supplier.zip}", :size => 13, :spacing => 4
end

if @movement.supplier.country and @movement.supplier.country != ""
  pdf.text "Country: #{@movement.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @movement.get_products()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@movement.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@movement.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@movement.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@movement.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]