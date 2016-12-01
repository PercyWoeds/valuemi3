pdf.font "Helvetica"

pdf.text "Company: #{@delivery.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "delivery: #{@delivery.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@delivery.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@delivery.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@delivery.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@delivery.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Customer information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@delivery.customer.name}", :size => 13, :spacing => 4

if @delivery.customer.email and @delivery.customer.email != ""
  pdf.text "Email: #{@delivery.customer.email}", :size => 13, :spacing => 4
end

if @delivery.customer.account and @delivery.customer.account != ""
  pdf.text "Account: #{@delivery.customer.account}", :size => 13, :spacing => 4
end

if @delivery.customer.phone1 and @delivery.customer.phone1 != ""
  pdf.text "Phone 1: #{@delivery.customer.phone1}", :size => 13, :spacing => 4
end

if @delivery.customer.phone2 and @delivery.customer.phone2 != ""
  pdf.text "Phone 2: #{@delivery.customer.phone2}", :size => 13, :spacing => 4
end

if @delivery.customer.address1 and @delivery.customer.address1 != ""
  pdf.text "Address 1: #{@delivery.customer.address1}", :size => 13, :spacing => 4
end

if @delivery.customer.address2 and @delivery.customer.address2 != ""
  pdf.text "Address 2: #{@delivery.customer.address2}", :size => 13, :spacing => 4
end

if @delivery.customer.city and @delivery.customer.city != ""
  pdf.text "City: #{@delivery.customer.city}", :size => 13, :spacing => 4
end

if @delivery.customer.state and @delivery.customer.state != ""
  pdf.text "State: #{@delivery.customer.state}", :size => 13, :spacing => 4
end

if @delivery.customer.zip and @delivery.customer.zip != ""
  pdf.text "ZIP: #{@delivery.customer.zip}", :size => 13, :spacing => 4
end

if @delivery.customer.country and @delivery.customer.country != ""
  pdf.text "Country: #{@delivery.customer.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @delivery.get_services()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@delivery.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@delivery.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@delivery.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@delivery.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]