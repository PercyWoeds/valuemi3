pdf.font "Helvetica"

pdf.text "Company: #{@output.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "output: #{@output.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@output.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@output.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@output.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@output.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Customer information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@output.customer.name}", :size => 13, :spacing => 4

if @output.customer.email and @output.customer.email != ""
  pdf.text "Email: #{@output.customer.email}", :size => 13, :spacing => 4
end

if @output.customer.account and @output.customer.account != ""
  pdf.text "Account: #{@output.customer.account}", :size => 13, :spacing => 4
end

if @output.customer.phone1 and @output.customer.phone1 != ""
  pdf.text "Phone 1: #{@output.customer.phone1}", :size => 13, :spacing => 4
end

if @output.customer.phone2 and @output.customer.phone2 != ""
  pdf.text "Phone 2: #{@output.customer.phone2}", :size => 13, :spacing => 4
end

if @output.customer.address1 and @output.customer.address1 != ""
  pdf.text "Address 1: #{@output.customer.address1}", :size => 13, :spacing => 4
end

if @output.customer.address2 and @output.customer.address2 != ""
  pdf.text "Address 2: #{@output.customer.address2}", :size => 13, :spacing => 4
end

if @output.customer.city and @output.customer.city != ""
  pdf.text "City: #{@output.customer.city}", :size => 13, :spacing => 4
end

if @output.customer.state and @output.customer.state != ""
  pdf.text "State: #{@output.customer.state}", :size => 13, :spacing => 4
end

if @output.customer.zip and @output.customer.zip != ""
  pdf.text "ZIP: #{@output.customer.zip}", :size => 13, :spacing => 4
end

if @output.customer.country and @output.customer.country != ""
  pdf.text "Country: #{@output.customer.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @output.get_products()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@output.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@output.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@output.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@output.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]