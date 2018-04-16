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

      pdf.move_down 5
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "Almacen :  " 
    pdf.text " Categoria : " + @namecategoria , :size => 11 
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
      @cantidad = 0
      @totales  = 0
      saldo = 0  

       for  product in @movements

              row = []
              row << nroitem.to_s
              row << product.code
              row << product.name
              row << product.unidad
              row << product.ubicacion               
              row << product.quantity
              row << " "
              row << " "
              
              table_content << row
              nroitem=nroitem + 1

            
           
        end
            
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
      	                                  columns([3]).align=:left
                                          columns([4]).align=:left 
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                          columns([7]).align=:right 
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
    @fecha1= "2017-01-01 00:00:00"
    @fecha2 = params[:fecha1]
    @categoria = params[:products_category_id]
    @namecategoria= @company.get_categoria_name(@categoria)      
    @movements = @company.get_stocks_inventarios4(@categoria)
      
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
    
    pdf.text "Stocks de Productos :" +" Desde : "+@fecha1.to_s + " Hasta: "+@fecha2.to_s   , :size => 11 
    pdf.text " Categoria : " + @namecategoria , :size => 11 
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
      @cantidad1 = 0
      @cantidad2 = 0
      @cantidad3 = 0
      @cantidad = 0

      @totales  = 0
        

       for  stock in @movements 
              row = []
              row << nroitem.to_s
              row << stock.product.code
              row << stock.product.name
              row << stock.product.unidad
              row << stock.product.ubicacion 
              row << sprintf("%.3f",stock.price.round(3).to_s)
              row << sprintf("%.2f",stock.stock_inicial.round(2).to_s)         
              row << sprintf("%.2f",stock.ingreso.round(2).to_s)
              row << sprintf("%.2f",stock.salida.round(2).to_s)
              saldo = stock.stock_inicial  + stock.ingreso - stock.salida       
              row << sprintf("%.2f",saldo.round(2).to_s)
              if stock.price 
              @total = saldo * stock.price                         
              else
              @total = 0  
              end
              row << sprintf("%.2f",@total.round(2).to_s)
              @cantidad1 += stock.stock_inicial 
              @cantidad2 += stock.ingreso 
              @cantidad3 += stock.salida  
              @cantidad  += saldo 

              @totales  += @total 

              table_content << row
              nroitem=nroitem + 1
              end 



           row = []
            row << ""
            row <<""          
            row << "TOTALES GENERAL"
            row << ""            
            row << ""            
            row <<""          
            row << sprintf("%.2f",@cantidad1.round(2).to_s)
            row << sprintf("%.2f",@cantidad2.round(2).to_s)                                  
            row << sprintf("%.2f",@cantidad3.round(2).to_s)
            row << sprintf("%.2f",@cantidad.round(2).to_s)
            row << sprintf("%.2f",@totales.round(2).to_s)
            
            table_content << row


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left  
                                          columns([3]).align=:left  
                                          columns([4]).align=:right
                                          columns([5]).align=:right 
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
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
    @estado = params[:estado]
    
    @namecategoria= @company.get_categoria_name(@categoria)            
    @movements = @company.get_stocks_inventarios2(@fecha1,@fecha2,@categoria,@estado)   
      
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
      
    Prawn::Document.generate("app/pdf_output/stocks3.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/stocks3.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName    
    send_file("app/pdf_output/stocks3.pdf", :type => 'application/pdf', :disposition => 'inline')
  end


  #----------------------------------------------------------------------------------
# REPORTE DE MOVIMIENTO DE STOCK DETALLADO 
#----------------------------------------------------------------------------------

  def build_pdf_header4(pdf)
      pdf.font "Helvetica" , :size => 8

     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s
    pdf.text "FORMATO 13.1: REGISTRO DE INVENTARIO PERMANENTE VALORIZADO - DETALLE DEL INVENTARIO VALORIZADO "
    pdf.text "PERIODO : " +@fecha1.to_s+ " Hasta: "+@fecha2.to_s   , :size => 11 
    pdf.text "RUC : 2010010010101"  
    pdf.text "APELLIDOS Y NOMBRES, DENOMINACION O RAZON SOCIAL : TRANSPORTES PEREDA SRL"
    pdf.text "ESTABLECIMIENTO : ALMACEN"

      pdf 
  end   

  def build_pdf_body4(pdf)
    
        pdf.font "Helvetica" , :size => 6

        headers = []
        headers1 = []
        table_content = []

       inner_table0 = "DOCUMENTO DE TRASLADO,
       COMPROBANTE DE PAGO"
       inner_table1 = "DOCUMENTO
       INTERNO
       O SIMILAR"
       inner_table3 = "TIPO DE "
       inner_table4 = "OPERACION "
       inner_table5 = "TABLA 12"

         data =[[{:content=> inner_table0,:colspan=>4},inner_table3,{:content=>"ENTRADAS ",:colspan=>3},{:content=>"SALIDAS ",:colspan=>3},"SALDO" ] ,
               [{:content=> inner_table1,:colspan=>4},inner_table4,"CANTIDAD","COSTO UNIT.","COSTO TOTAL","CANTIDAD","COSTO UNIT.","COSTO TOTAL","CANTIDAD","COSTO UNIT.","COSTO TOTAL"],
["FECHA","TIPO","SERIE","NUMERO"] ]
                    
      nroitem = 1
      @cantidad1 = 0
      @cantidad2 = 0
      @cantidad3 = 0
      @cantidad4 = 0
      @totales  = 0

      total1 = 0
      total2 = 0 
        
      lcCli = @movements.first.product_id    
      lcDatos = @movements.first      
      if lcDatos.product   
              pdf.text  "CODIGO DE LA EXISTENCIA :" << lcDatos.product.code 
              pdf.text  "TIPO : 05 SUMINISTROS"
              pdf.text  "DESCRIPCION : "<< @namecategoria
              pdf.text  "CODIGO DE LA UNIDAD DE MEDIDAD : UNIDADES " 
              pdf.text  "METODO DE VALUACION : ULTIMO PRECIO"
      else
              pdf.text  "CODIGO DE LA EXISTENCIA :" 
              pdf.text  "TIPO : 05 SUMINISTROS"
              pdf.text  "DESCRIPCION : "
              pdf.text  "CODIGO DE LA UNIDAD DE MEDIDA : UNIDADES " 
              pdf.text  "METODO DE VALUACION : ULTIMO PRECIO"
      end 
      #{:border_width=>1  }.each do |property,value|
      #       pdf.text " Instrucciones: "
      #       pdf.table(data,:cell_style=> {property =>value})
      #       pdf.move_down 20          
      #      end 
    Stock::TABLE_HEADERS41.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers1 << cell
      end

    Stock::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers1
      table_content << headers
      @cantidad1 = 0
      @cantidad2 = 0
      @cantidad3 = 0
      @cantidad4 = 0
      @cantidad5 = 0
      @cantidad6 = 0
      @tcantidad1 = 0
      @tcantidad2 = 0
      @tcantidad3 = 0
      @tcantidad4 = 0
      
      if @movements
        
        lcProduct = @movements.first.product_id 
        
        for  stock in @movements 
        
            if lcProduct == stock.product_id
               row = []                                    
               row << stock.product.code
               row << stock.product.name                   
               row << stock.fecha.strftime("%d%m%Y")                
               row << stock.document.descripshort  
               row << " " 
               row << stock.documento                           
               row << stock.tm

                row << sprintf("%.2f",stock.ingreso.to_s)
                  
                row << sprintf("%.2f",stock.costo_ingreso.to_s)
                
                total1 = stock.ingreso*stock.costo_ingreso
                row << sprintf("%.2f",total1.to_s)
              
                row << sprintf("%.2f",stock.salida.to_s)

                row << sprintf("%.2f",stock.costo_salida.to_s)

                total2 = stock.salida*stock.costo_salida
                
                row << sprintf("%.2f",total2.to_s)
              
              #saldo = stock.stock_inicial  + stock.ingreso - stock.salida       
              row << sprintf("%.2f",stock.stock_final.to_s)
              row << sprintf("%.2f",stock.costo_saldo.to_s)
              total3 = stock.stock_final*stock.costo_saldo
              row << sprintf("%.2f",total3.to_s) 

              table_content << row
              @cantidad1 += stock.ingreso 
              @cantidad2 += total1
              @cantidad3 += stock.salida
              @cantidad4 += total2
            else
              
               lcProduct = stock.product_id
               @cantidad5 += stock.stock_final
               @cantidad6 += total3
               
               row = []                                    
               row << stock.product.code
               row << stock.product.name                   
               row << stock.fecha.strftime("%d%m%Y")                
               row << stock.document.descripshort  
               row << " " 
               row << stock.documento                           
               row << stock.tm

                row << sprintf("%.2f",stock.ingreso.to_s)
                  
                row << sprintf("%.2f",stock.costo_ingreso.to_s)
                
                total1 = stock.ingreso*stock.costo_ingreso
                row << sprintf("%.2f",total1.to_s)
              
                row << sprintf("%.2f",stock.salida.to_s)

                row << sprintf("%.2f",stock.costo_salida.to_s)

                total2 = stock.salida*stock.costo_salida
                
                row << sprintf("%.2f",total2.to_s)
              
              #saldo = stock.stock_inicial  + stock.ingreso - stock.salida       
              row << sprintf("%.2f",stock.stock_final.to_s)
              row << sprintf("%.2f",stock.costo_saldo.to_s)
              total3 = stock.stock_final*stock.costo_saldo
              row << sprintf("%.2f",total3.to_s) 

              table_content << row
              
              @cantidad1 += stock.ingreso 
              @cantidad2 += total1
              
              @cantidad3 += stock.salida
              @cantidad4 += total2
            
             
              
            end
            
        end  
             
              @cantidad5 += stock.stock_final
              @cantidad6 += total3
               
             row = []
             row << ""
             row << ""
             row << ""
             row << ""
             row << ""
             row << ""
             
             row << "TOTALES"
             row << sprintf("%.2f",@cantidad1.to_s)
             row << " "
             row << sprintf("%.2f",@cantidad2.to_s)
             row << sprintf("%.2f",@cantidad3.to_s)
             row << " "
             row << sprintf("%.2f",@cantidad4.to_s)
             row << sprintf("%.2f",@cantidad5.to_s)
             row << ""
             row << sprintf("%.2f",@cantidad6.to_s)
             
              table_content << row            
              result = pdf.table table_content, {:position => :center,
                                                :header => true,
                                                :width => pdf.bounds.width
                                                } do 
                                                  columns([0]).align =:center                                             
                                                  columns([1]).align =:left                                              
                                                  columns([2]).align =:left                                                                                             
                                                  columns([3]).align =:left  
                                                  columns([4]).align =:right
                                                  columns([5]).align =:right                                              
                                                  columns([6]).align =:right
                                                  columns([7]).align =:right
                                                  columns([8]).align =:right                                               
                                                  columns([9]).align =:right
                                                  columns([10]).align =:right
                                                  columns([11]).align =:right                                                
                                                  columns([12]).align =:right
                                                  columns([13]).align =:right
                                                  columns([14]).align =:right
                                                  
                                                end                                          
                pdf.move_down 10
    
              @cantidad1 = 0
              @cantidad2 = 0
              @cantidad3 = 0
              @cantidad4 = 0
              @cantidad5 = 0
              @cantidad6 = 0
              
              total1 = 0
              total2 = 0                
            
             $lcCliName = stock.product.name
             lcCli = stock.product_id 

             headers = []
             headers1 = []
             table_content = []      
      pdf 
      end 
  
end 


    def build_pdf_footer4(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf      
  end


  def rpt_stocks4
    
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1] 
    @fecha2 = params[:fecha2] 
    @categoria =params[:products_category_id]
    
    @namecategoria= @company.get_categoria_name(@categoria)            

    @movements = @company.get_stocks_inventarios3(@fecha1,@fecha2,@categoria)   
      
    Prawn::Document.generate("app/pdf_output/stocks4.pdf") do |pdf|            

        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })
        pdf.start_new_page(:size => "A3")
        pdf.font "Open Sans",:size =>6
        
        pdf = build_pdf_header4(pdf)
        pdf = build_pdf_body4(pdf)
        build_pdf_footer4(pdf)
        $lcFileName =  "app/pdf_output/stocks4.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName    
    send_file("app/pdf_output/stocks4.pdf", :type => 'application/pdf', :disposition => 'inline')
    MovementDetail.delete_all 
  end



  def show
    @stock = Stock.find(params[:id])

    @product = @stock.get_ingresos(@stock.product_id)

  end



end
