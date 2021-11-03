class HardWorkerWorker30
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true 

  
  def perform(fecha1,fecha2,user_id)
    # Build the big, slow report into a zip file
  

    @company = Company.find(1)
    @user = User.find(user_id)
    @directory = "app/pdf_output"
   
    @key="Rpt_resumen_lqd.pdf"

    @fecha1 = fecha1
    @fecha2 = fecha2 

   
    
    @tanques  = @company.get_tanques() 
    @varillaje = @company.get_varillas()
  
   
    @tanques  = @company.get_tanques() 
    @varillaje = @company.get_varillas()
  
       
     if @varillaje  != nil 

        Prawn::Document.generate "#{@directory}/#{@key}", :page_layout => :landscape   do |pdf|            
            pdf.font_families.update("Open Sans" => {
              :normal => "app/assets/fonts/OpenSans-Regular.ttf",
              :italic => "app/assets/fonts/OpenSans-Italic.ttf",
            })

            pdf.font "Open Sans",:size =>6
            pdf = build_pdf_header_rpt16(pdf)
            pdf = build_pdf_body_rpt16(pdf)
            build_pdf_footer_rpt16(pdf)
            
        end 

        send_file("#{@directory}/#{@key}", :type => 'application/pdf', :disposition => 'inline')

      end 

   
        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open("#{@directory}/#{@key}", 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file

        @user.most_recent_report = download_url


        if @user.save 
            
         puts  "actul ok "

        end 

            # Notify the user that the download is ready
                
       # puts user.email 


        ActionCorreo.notify_followers(@user.email, @user).deliver_now

    

  end



##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS pivot
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt16(pdf)
     pdf.font "Helvetica" , :size => 6
      
     $lcCli  = @company.name 
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
      
      pdf 
  end   

  def build_pdf_body_rpt16(pdf)
    
    pdf.text "OSINERMIN   "+ "Desde "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 8
    pdf.text ""
    pdf.font "Helvetica" , :size => 5

      table_content = []
      total_general = 0
      total_factory = 0
      headers  = []

      Stock::TABLE_HEADERS5.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers
      nroitem = 1

       @cantidad1 =  0
       @cantidad2 =  0
       @cantidad3 =  0
       @cantidad4 =  0
       @cantidad5 =  0
       @cantidad6 =  0
       row = []   

       if @tanques 

           for tanques0  in @tanques 
             row = []               
             row << tanques0.product.code 
             row << ""
             row <<  tanques0.product.name 
             row << ""
             row << ""
             row << ""             
             row << ""
             row << ""
             row << ""
             row << ""
             row << ""             
             row << ""
             table_content << row             

            @fecha0="2021-07-01" 
            @varillas0 = @varillaje.first.get_varilla(@fecha0,@fecha0,tanques0.id ) 
            
            @varillas = @varillaje.first.get_varilla(@fecha1,@fecha2,tanques0.id )  

             if @varillas0.first.nil? 
              saldo_inicial = 0 
             else 
              saldo_inicial = @varillas0.first.inicial 
             end 

              if @varillas       
                for  varillas  in @varillas            
                    total1 = 0
                    row = []                                  
                     qty_ingreso = varillas.get_ingresos(varillas.fecha.to_date,tanques0.product.id) 
                     qty_ventas  = varillas.get_ventas(varillas.fecha.to_date,tanques0.product.code)  
                     qty_ventas_serafin  = varillas.get_ventas_serafin(varillas.fecha.to_date,tanques0.product.code) 
                     fecha_dia_anterior = varillas.fecha.yesterday.to_date
                     row << varillas.fecha.to_date 
                     row << " 06:00 AM " 
                     row << varillas.get_saldo_inicial(fecha_dia_anterior,fecha_dia_anterior,tanques0.product.id).last.varilla               
                     row << sprintf("%.2f",qty_ingreso.to_s)  
                     row << sprintf("%.2f",qty_ventas_serafin.to_s)               
                     row << sprintf("%.2f",qty_ventas.to_s)  
                  
                     total1 = saldo_inicial +  qty_ingreso - qty_ventas + qty_ventas_serafin  
                      dif = total1 - varillas.varilla 
                      row << sprintf("%.2f",total1.to_s)

                      row << varillas.varilla
                      row << sprintf("%.2f",dif.to_s)
                      row << "" 
                      row << "" 
                      row << ""           
                        table_content << row         

                      total2 = 0                      
                     saldo_inicial = varillas.varilla
                 end            
               end 

            end            
          end 

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([0]).width = 50 
                                          columns([1]).align=:left

                                          columns([2]).align=:right
                                          columns([2]).width = 60 
                                          
                                          columns([3]).align=:right 
                                          columns([3]).width = 60
                                          columns([4]).align=:right
                                          columns([4]).width = 60
                                          columns([5]).align=:right 
                                          columns([5]).width = 60
                                          columns([6]).align=:right
                                          columns([6]).width = 60
                                          
                                          columns([7]).align=:right
                                          columns([7]).width = 60
                                           
                                          columns([8]).align=:right
                                          columns([8]).width = 60
                                          columns([9]).align=:right 
                                          columns([10]).align=:right
                                          columns([11]).align=:right 
                                          columns([12]).align=:right
                                          columns([13]).align=:right 
                                          
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    
    def build_pdf_footer_rpt16(pdf)

        subtotals = []
        taxes = []
        totals = []
        services_subtotal = 0
        services_tax = 0
        services_total = 0
        pdf.text "" 
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
           pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
        end

      pdf
      
    end

     def client_data_headers
      client_headers  = [["Empresa  :", @company.name ]]
      client_headers << ["Direccion :", @company.address1 ]
      client_headers
    end

    def invoice_headers         
        invoice_headers  = [["Fecha : ",$lcFecha1 ]]    
        invoice_headers
    end






end 