class StocksController < ApplicationController

##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS EMITIDAS
##-----------------------------------------------------------------------------------

def client_data_headers

    #{@serviceorder.description}
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha : ",$lcHora]]
    
      invoice_headers
  end


  def build_pdf_header(pdf)

    pdf.font "Helvetica"

     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

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

        pdf.move_down 10

      end

      pdf.move_down 15
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "Almacen : Central  Stocks  al : "+@fecha , :size => 11 
    pdf.text " Categoria : " + @namecategoria
    pdf.font "Open Sans",:size =>6

      headers = []
      table_content = []

      Stock::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end


      table_content << headers

      nroitem=1
      @totales = 0
      @cantidad = 0
      importe = 0

       for  stock in @stocks1           
            row = []
            row << nroitem.to_s
          if stock.product != nil   
            row << stock.product.code
            row << stock.product.name
            end 
            row << stock.quantity
            if stock.unitary_cost != nil
            row << sprintf("%.2f",stock.unitary_cost.to_s)
            importe = stock.unitary_cost.round(2)*stock.quantity.round(2)
            row << sprintf("%.2f",importe.to_s)
            row << stock.get_estado 
            if stock.unitary_cost == nil

            else   
            @totales = @totales +  (stock.unitary_cost * stock.quantity)
            @cantidad += stock.quantity

            end 
            table_content << row
            nroitem=nroitem + 1           
          else 
            row << " "
            importe = 0 
          end


            
        end
            row = []
            row << ""
            row <<""          
            row << "TOTALES GENERAL"
            row << sprintf("%.2f",@cantidad.round(2).to_s)
            row << " "
            row << sprintf("%.2f",@totales.round(2).to_s)
            row << " " 
            table_content << row

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
      	                                  columns([3]).align=:right
                                          columns([4]).align=:right
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:left
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  # Export serviceorder to PDF
  def rpt_stocks1
    @company=Company.find(params[:company_id])      

    @fecha = params[:fecha1]
    @categoria = params[:products_category_id]
    @namecategoria= @company.get_categoria_name(@categoria)      

    @stocks1 = @company.get_stocks(@categoria)

      
    Prawn::Document.generate("app/pdf_output/stocks1.pdf") do |pdf|      

        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/stocks1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/stocks1.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

#----------------------------------------------------------------------------------
# REPORTE DE MOVIMIENTO DE STOCK 
#----------------------------------------------------------------------------------

  def build_pdf_header2(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

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

        pdf.move_down 10

      end


      pdf.move_down 15
      pdf 
  end   

  def build_pdf_body2(pdf)
    
    pdf.text "Movimiento  de Productos :" +" Desde : "+@fecha1.to_s + " Hasta: "+@fecha2.to_s   , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Stock::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end


      table_content << headers

      nroitem=1
      totingreso = 0
      totsalida  = 0

      
       lcProducto = @movements.first.product_id 

       for  stock in @movements 

          if lcProducto == stock.product_id 

              totingreso += stock.ingreso
              totsalida  += stock.salida

          else 

              row = []
              row << nroitem.to_s
              row << stock.product.code
              row << stock.product.name
              row << stock.product.unidad
              row << stock.product.ubicacion 
              row << stock.price
              row << stock.stock_inicial        
              row << totingreso
              row << totsalida 
              saldo = stock.stock_inicial  + totingreso - totsalida       
              row << saldo 

              table_content << row
              nroitem=nroitem + 1
              lcProducto = stock.product_id
              
          end   

        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:center 
                                          columns([3]).align=:left  
                                          columns([4]).align=:right
                                          columns([5]).align=:right 
                                          columns([6]).align=:right
                                          columns([7]).align=:right

                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer2(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf      
  end

  def do_stocks

    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Stocks "


        if(params[:search] and params[:search] != "")  

          @stocks = Stock.find_by_sql(['Select stocks.*, products.name from stocks 
          INNER JOIN products ON stocks.product_id = products.id
          WHERE products.code like ?  or products.name like ?',
          params[:search], "%"+ params[:search]+"%"]).paginate(:page => params[:page])
        else
          @stocks = Stock.paginate(:page => params[:page]) 
        end

    
  end 

  # Export serviceorder to PDF
  def rpt_stocks2
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1] 
    @fecha2 = params[:fecha2] 
    @categoria =params[:products_category_id]
      
    @movements = @company.get_stocks_inventarios2(@fecha1,@fecha2,@categoria)   
      
    Prawn::Document.generate("app/pdf_output/stocks2.pdf") do |pdf|            
        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/stocks2.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName    
    send_file("app/pdf_output/stocks2.pdf", :type => 'application/pdf', :disposition => 'inline')
    MovementDetail.delete_all 
  end


  # Export serviceorder to PDF
  def rpt_stocks3
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1] 
    @fecha2 = params[:fecha2]   
      
    @movements = @company.get_movement_stocks(@fecha1,@fecha2) 
      
    Prawn::Document.generate("app/pdf_output/stocks2.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/stocks2.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName    
    send_file("app/pdf_output/stocks2.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

  def show
    @stock = Stock.find(params[:id])

    @product = @stock.get_ingresos(@stock.product_id)

  end



end
