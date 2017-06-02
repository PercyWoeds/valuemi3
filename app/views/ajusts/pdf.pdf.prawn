pdf.font "Helvetica"

pdf.text "Company: #{@ajust.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4


pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@ajust.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@ajust.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@ajust.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "supplier information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @ajust.get_products()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@ajust.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@ajust.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@ajust.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@ajust.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]