pdf.font "Helvetica"

pdf.text "Company: #{@order.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Documento: #{@order.id}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Codigo: #{@order.id}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@invoice.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Igv: $#{money(@invoice.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@invoice.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Customer information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

#pdf.text "Name: #{@invoice.customer.name}", :size => 13, :spacing => 4

#if @invoice.customer.country and @invoice.customer.country != ""
#  pdf.text "Country: #{@invoice.customer.country}", :size => 13, :spacing => 4
#end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product  in @invoice.get_products()
  pdf.text "#{product.name} - Price: $#{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: $#{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@order.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@order.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@order.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@order.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]