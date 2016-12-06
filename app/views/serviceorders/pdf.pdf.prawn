pdf.font "Helvetica"

pdf.text "Company: #{@serviceorder.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "serviceorder: #{@serviceorder.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@serviceorder.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@serviceorder.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@serviceorder.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@serviceorder.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Customer information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@serviceorder.customer.name}", :size => 13, :spacing => 4

if @serviceorder.customer.email and @serviceorder.customer.email != ""
  pdf.text "Email: #{@serviceorder.customer.email}", :size => 13, :spacing => 4
end

if @serviceorder.customer.account and @serviceorder.customer.account != ""
  pdf.text "Account: #{@serviceorder.customer.account}", :size => 13, :spacing => 4
end

if @serviceorder.customer.phone1 and @serviceorder.customer.phone1 != ""
  pdf.text "Phone 1: #{@serviceorder.customer.phone1}", :size => 13, :spacing => 4
end

if @serviceorder.customer.phone2 and @serviceorder.customer.phone2 != ""
  pdf.text "Phone 2: #{@serviceorder.customer.phone2}", :size => 13, :spacing => 4
end

if @serviceorder.customer.address1 and @serviceorder.customer.address1 != ""
  pdf.text "Address 1: #{@serviceorder.customer.address1}", :size => 13, :spacing => 4
end

if @serviceorder.customer.address2 and @serviceorder.customer.address2 != ""
  pdf.text "Address 2: #{@serviceorder.customer.address2}", :size => 13, :spacing => 4
end

if @serviceorder.customer.city and @serviceorder.customer.city != ""
  pdf.text "City: #{@serviceorder.customer.city}", :size => 13, :spacing => 4
end

if @serviceorder.customer.state and @serviceorder.customer.state != ""
  pdf.text "State: #{@serviceorder.customer.state}", :size => 13, :spacing => 4
end

if @serviceorder.customer.zip and @serviceorder.customer.zip != ""
  pdf.text "ZIP: #{@serviceorder.customer.zip}", :size => 13, :spacing => 4
end

if @serviceorder.customer.country and @serviceorder.customer.country != ""
  pdf.text "Country: #{@serviceorder.customer.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @serviceorder.get_products()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@serviceorder.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@serviceorder.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@serviceorder.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@serviceorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]