
    

      max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 20

      end


pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@serviceorder.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@serviceorder.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@serviceorder.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@serviceorder.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@serviceorder.supplier.name}", :size => 13, :spacing => 4

if @serviceorder.supplier.email and @serviceorder.supplier.email != ""
  pdf.text "Email: #{@serviceorder.supplier.email}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.account and @serviceorder.supplier.account != ""
  pdf.text "Account: #{@serviceorder.supplier.account}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.phone1 and @serviceorder.supplier.phone1 != ""
  pdf.text "Phone 1: #{@serviceorder.supplier.phone1}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.phone2 and @serviceorder.supplier.phone2 != ""
  pdf.text "Phone 2: #{@serviceorder.supplier.phone2}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.address1 and @serviceorder.supplier.address1 != ""
  pdf.text "Address 1: #{@serviceorder.supplier.address1}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.address2 and @serviceorder.supplier.address2 != ""
  pdf.text "Address 2: #{@serviceorder.supplier.address2}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.city and @serviceorder.supplier.city != ""
  pdf.text "City: #{@serviceorder.supplier.city}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.state and @serviceorder.supplier.state != ""
  pdf.text "State: #{@serviceorder.supplier.state}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.zip and @serviceorder.supplier.zip != ""
  pdf.text "ZIP: #{@serviceorder.supplier.zip}", :size => 13, :spacing => 4
end

if @serviceorder.supplier.country and @serviceorder.supplier.country != ""
  pdf.text "Country: #{@serviceorder.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @serviceorder.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@serviceorder.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@serviceorder.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@serviceorder.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@serviceorder.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@serviceorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    