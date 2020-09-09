class HardWorkerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true 

  
  def perform(fecha1,fecha2,user_id)
    # Build the big, slow report into a zip file
  

    @company = Company.find(1)
    @user = User.find(user_id)
    @directory = "app/pdf_output"
   

    @key="RptPersonal.pdf"

    Sellvale.where(dia:nil).update_all(dia: "sellvales.fecha.day")

    @fecha1 = fecha1
    @fecha2 = fecha2 
    

    @facturas_rpt = @company.get_employees_asis(@fecha1,@fecha2)  


    if @facturas_rpt != nil 

    Prawn::Document.generate "#{@directory}/#{@key}", :page_layout => :landscape   do |pdf|            
        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
        pdf = build_pdf_header_rpt15(pdf)
        pdf = build_pdf_body_rpt15(pdf)
        build_pdf_footer_rpt15(pdf)
       
        
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

  end

  #----------------------------------------------------------------------------------
# REPORTE DE MOVIMIENTO DE STOCK 
#----------------------------------------------------------------------------------

##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS pivot
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt15(pdf)
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

  def build_pdf_body_rpt15(pdf)
    
    pdf.text "Resumen Asistencia Personal  "+ "Desde "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0

      Sellvale::TABLE_HEADERS9.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

      # tabla pivoteadas
      # hash of hashes
        # pad columns with spaces and bars from max_lengths

      @total_general = 0
      @total_anterior = 0
      @total_cliente = 0 
      @total_dia01 = 0
      @total_dia02 = 0
      @total_dia03 = 0
      @total_dia04 = 0
      @total_dia05 = 0
      @total_dia06 = 0
      @total_dia07 = 0
      @total_dia08 = 0
      @total_dia09 = 0
      @total_dia10 = 0
      @total_dia11 = 0
      @total_dia12 = 0
      @total_dia13 = 0
      @total_dia14 = 0
      @total_dia15 = 0
      @total_dia16 = 0
      @total_dia17 = 0
      @total_dia18 = 0
      @total_dia19 = 0
      @total_dia20 = 0
      @total_dia21 = 0
      @total_dia22 = 0
      @total_dia23 = 0
      @total_dia24 = 0
      @total_dia25 = 0
      @total_dia26 = 0
      @total_dia27 = 0
      @total_dia28 = 0
      @total_dia29 = 0
      @total_dia30 = 0
      @total_dia31 = 0
      
      
      @total_anterior_column = 0
      @total_dia01_column = 0
      @total_dia02_column = 0
      @total_dia03_column = 0
      @total_dia04_column = 0
      @total_dia05_column = 0
      @total_dia06_column = 0
      @total_dia07_column = 0
      @total_dia08_column = 0
      @total_dia09_column = 0
      @total_dia10_column = 0
      @total_dia11_column = 0
      @total_dia12_column = 0
      @total_dia13_column = 0
      @total_dia14_column = 0
      @total_dia15_column = 0
      @total_dia16_column = 0
      @total_dia17_column = 0
      @total_dia18_column = 0
      @total_dia19_column = 0
      @total_dia20_column = 0
      @total_dia21_column = 0
      @total_dia22_column = 0
      @total_dia23_column = 0
      @total_dia24_column = 0
      @total_dia25_column = 0
      @total_dia26_column = 0
      @total_dia27_column = 0
      @total_dia28_column = 0
      @total_dia29_column = 0
      @total_dia30_column = 0
      @total_dia31_column = 0
      
      
      lcCli = @facturas_rpt.first.cod_emp
      $lcCliName = ""
    

     for  customerpayment_rpt in @facturas_rpt

        if lcCli == customerpayment_rpt.cod_emp 

          $lcCliName =customerpayment_rpt.get_empleado_nombre(customerpayment_rpt.cod_emp)
          
          if customerpayment_rpt.dia_month == 1
            @total_dia01 +=  customerpayment_rpt.turno 
          end             
          
          if customerpayment_rpt.dia_month == 2
            @total_dia02 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 3
            @total_dia03 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 4
            @total_dia04 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 5
            @total_dia05 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 6
            @total_dia06 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 7
            @total_dia07 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 8
            @total_dia08 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 9
            @total_dia09 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 10
            @total_dia10 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 11
            @total_dia11 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 12
            @total_dia12 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 13
            @total_dia13 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 14
            @total_dia14 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 15
            @total_dia15 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 16
            @total_dia16 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 17
            @total_dia17 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 18
            @total_dia18 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 19
            @total_dia19 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 20
            @total_dia20 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 21
            @total_dia21 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 22
            @total_dia22 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 23
            @total_dia23 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 24
            @total_dia24 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 25
            @total_dia25 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 26
            @total_dia26 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 27
            @total_dia27 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 28
            @total_dia28 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 29
            @total_dia29  +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 30
            @total_dia30 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 31
            @total_dia31 +=  customerpayment_rpt.turno 
          end             
          
          
          
        else
          
            @total_cliente =@total_dia01+
            @total_dia02+
            @total_dia03+
            @total_dia04+
            @total_dia05+
            @total_dia06+
            @total_dia07+
            @total_dia08+
            @total_dia09+
            @total_dia10+
            @total_dia11+
            @total_dia12
            @total_dia13+
            @total_dia14+
            @total_dia15+
            @total_dia16+
            @total_dia17+
            @total_dia18+
            @total_dia19+
            @total_dia20+
            @total_dia21+
            @total_dia22+
            @total_dia23+
            @total_dia24+
            @total_dia25+
            @total_dia26+
            @total_dia27+
            @total_dia28+
            @total_dia29+
            @total_dia30+
            @total_dia31
            
            
            row = []
            row << nroitem.to_s        
            row << $lcCliName
            row << sprintf("%.1f",@total_dia01.to_s)
            row << sprintf("%.1f",@total_dia02.to_s)
            row << sprintf("%.1f",@total_dia03.to_s)
            row << sprintf("%.1f",@total_dia04.to_s)
            row << sprintf("%.1f",@total_dia05.to_s)
            row << sprintf("%.1f",@total_dia06.to_s)
            row << sprintf("%.1f",@total_dia07.to_s)
            row << sprintf("%.1f",@total_dia08.to_s)
            row << sprintf("%.1f",@total_dia09.to_s)
            row << sprintf("%.1f",@total_dia10.to_s)
            row << sprintf("%.1f",@total_dia11.to_s)
            row << sprintf("%.1f",@total_dia12.to_s)
            row << sprintf("%.1f",@total_dia13.to_s)
            row << sprintf("%.1f",@total_dia14.to_s)
            row << sprintf("%.1f",@total_dia15.to_s)
            row << sprintf("%.1f",@total_dia16.to_s)
            row << sprintf("%.1f",@total_dia17.to_s)
            row << sprintf("%.1f",@total_dia18.to_s)
            row << sprintf("%.1f",@total_dia19.to_s)
            row << sprintf("%.1f",@total_dia20.to_s)
            row << sprintf("%.1f",@total_dia21.to_s)
            row << sprintf("%.1f",@total_dia22.to_s)
            row << sprintf("%.1f",@total_dia23.to_s)
            row << sprintf("%.1f",@total_dia24.to_s)
            row << sprintf("%.1f",@total_dia25.to_s)
            row << sprintf("%.1f",@total_dia26.to_s)
            row << sprintf("%.1f",@total_dia27.to_s)
            row << sprintf("%.1f",@total_dia28.to_s)
            row << sprintf("%.1f",@total_dia29.to_s)
            row << sprintf("%.1f",@total_dia30.to_s)
            row << sprintf("%.1f",@total_dia31.to_s)
            
            row << sprintf("%.1f",@total_cliente.to_s)

            table_content << row            
            ## TOTAL XMES GENERAL
            
            @total_dia01_column += @total_dia01
            @total_dia02_column += @total_dia02
            @total_dia03_column += @total_dia03
            @total_dia04_column += @total_dia04
            @total_dia05_column += @total_dia05
            @total_dia06_column += @total_dia06
            @total_dia07_column += @total_dia07
            @total_dia08_column += @total_dia08
            @total_dia09_column += @total_dia09
            @total_dia10_column += @total_dia10
            @total_dia11_column += @total_dia11
            @total_dia12_column += @total_dia12
            @total_dia13_column += @total_dia13
            @total_dia14_column += @total_dia14
            @total_dia15_column += @total_dia15
            @total_dia16_column += @total_dia16
            @total_dia17_column += @total_dia17
            @total_dia18_column += @total_dia18
            @total_dia19_column += @total_dia19
            @total_dia20_column += @total_dia20
            @total_dia21_column += @total_dia21
            @total_dia22_column += @total_dia22
            @total_dia23_column += @total_dia23
            @total_dia24_column += @total_dia24
            @total_dia25_column += @total_dia25
            @total_dia26_column += @total_dia26
            @total_dia27_column += @total_dia27
            @total_dia28_column += @total_dia28
            @total_dia29_column += @total_dia29
            @total_dia30_column += @total_dia30
            @total_dia31_column += @total_dia31
            
            
            
            @total_cliente = 0 
            ## TOTAL XMES GENERAL

            $lcCliName =customerpayment_rpt.get_empleado_nombre(customerpayment_rpt.cod_emp)
            lcCli = customerpayment_rpt.cod_emp


            
            @total_dia01 = 0
            @total_dia02 = 0
            @total_dia03 = 0
            @total_dia04 = 0
            @total_dia05 = 0
            @total_dia06 = 0
            @total_dia07 = 0
            @total_dia08 = 0
            @total_dia09 = 0
            @total_dia10 = 0
            @total_dia11 = 0
            @total_dia12 = 0
            @total_dia13 = 0
            @total_dia14 = 0
            @total_dia15 = 0
            @total_dia16 = 0
            @total_dia17 = 0
            @total_dia18 = 0
            @total_dia19 = 0
            @total_dia20 = 0
            @total_dia21 = 0
            @total_dia22 = 0
            @total_dia23 = 0
            @total_dia24 = 0
            @total_dia25 = 0
            @total_dia26 = 0
            @total_dia27 = 0
            @total_dia28 = 0
            @total_dia29 = 0
            @total_dia30 = 0
            @total_dia31 = 0
            
            @total_cliente = 0 

          if customerpayment_rpt.dia_month == 1
            @total_dia01 +=  customerpayment_rpt.turno 
          end             
          
          if customerpayment_rpt.dia_month == 2
            @total_dia02 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 3
            @total_dia03 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 4
            @total_dia04 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 5
            @total_dia05 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 6
            @total_dia06 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 7
            @total_dia07 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 8
            @total_dia08 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 9
            @total_dia09 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 10
            @total_dia10 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 11
            @total_dia11 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 12
            @total_dia12 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 13
            @total_dia13 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 14
            @total_dia14 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 15
            @total_dia15 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 16
            @total_dia16 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 17
            @total_dia17 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 18
            @total_dia18 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 19
            @total_dia19 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 20
            @total_dia20 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 21
            @total_dia21 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 22
            @total_dia22 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 23
            @total_dia23 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 24
            @total_dia24 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 25
            @total_dia25 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 26
            @total_dia26 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 27
            @total_dia27 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 28
            @total_dia28 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 29
            @total_dia29  +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 30
            @total_dia30 +=  customerpayment_rpt.turno 
          end             
          if customerpayment_rpt.dia_month == 31
            @total_dia31 +=  customerpayment_rpt.turno 
          end             
          
          
          nroitem = nroitem + 1 
        end 
         @total_general = @total_general + customerpayment_rpt.turno
       end   

      #fin for
          #ultimo cliente 
  @total_cliente =@total_dia01+
            @total_dia02+
            @total_dia03+
            @total_dia04+
            @total_dia05+
            @total_dia06+
            @total_dia07+
            @total_dia08+
            @total_dia09+
            @total_dia10+
            @total_dia11+
            @total_dia12
            @total_dia13+
            @total_dia14+
            @total_dia15+
            @total_dia16+
            @total_dia17+
            @total_dia18+
            @total_dia19+
            @total_dia20+
            @total_dia21+
            @total_dia22+
            @total_dia23+
            @total_dia24+
            @total_dia25+
            @total_dia26+
            @total_dia27+
            @total_dia28+
            @total_dia29+
            @total_dia30+
            @total_dia31
            
          
            @total_dia01_column += @total_dia01
            @total_dia02_column += @total_dia02
            @total_dia03_column += @total_dia03
            @total_dia04_column += @total_dia04
            @total_dia05_column += @total_dia05
            @total_dia06_column += @total_dia06
            @total_dia07_column += @total_dia07
            @total_dia08_column += @total_dia08
            @total_dia09_column += @total_dia09
            @total_dia10_column += @total_dia10
            @total_dia11_column += @total_dia11
            @total_dia12_column += @total_dia12
            @total_dia13_column += @total_dia13
            @total_dia14_column += @total_dia14
            @total_dia15_column += @total_dia15
            @total_dia16_column += @total_dia16
            @total_dia17_column += @total_dia17
            @total_dia18_column += @total_dia18
            @total_dia19_column += @total_dia19
            @total_dia20_column += @total_dia20
            @total_dia21_column += @total_dia21
            @total_dia22_column += @total_dia22
            @total_dia23_column += @total_dia23
            @total_dia24_column += @total_dia24
            @total_dia25_column += @total_dia25
            @total_dia26_column += @total_dia26
            @total_dia27_column += @total_dia27
            @total_dia28_column += @total_dia28
            @total_dia29_column += @total_dia29
            @total_dia30_column += @total_dia30
            @total_dia31_column += @total_dia31
            
            
            row = []
            row << nroitem.to_s        
            row << $lcCliName
            row << sprintf("%.1f",@total_dia01.to_s)
            row << sprintf("%.1f",@total_dia02.to_s)
            row << sprintf("%.1f",@total_dia03.to_s)
            row << sprintf("%.1f",@total_dia04.to_s)
            row << sprintf("%.1f",@total_dia05.to_s)
            row << sprintf("%.1f",@total_dia06.to_s)
            row << sprintf("%.1f",@total_dia07.to_s)
            row << sprintf("%.1f",@total_dia08.to_s)
            row << sprintf("%.1f",@total_dia09.to_s)
            row << sprintf("%.1f",@total_dia10.to_s)
            row << sprintf("%.1f",@total_dia11.to_s)
            row << sprintf("%.1f",@total_dia12.to_s)
            row << sprintf("%.1f",@total_dia13.to_s)
            row << sprintf("%.1f",@total_dia14.to_s)
            row << sprintf("%.1f",@total_dia15.to_s)
            row << sprintf("%.1f",@total_dia16.to_s)
            row << sprintf("%.1f",@total_dia17.to_s)
            row << sprintf("%.1f",@total_dia18.to_s)
            row << sprintf("%.1f",@total_dia19.to_s)
            row << sprintf("%.1f",@total_dia20.to_s)
            row << sprintf("%.1f",@total_dia21.to_s)
            row << sprintf("%.1f",@total_dia22.to_s)
            row << sprintf("%.1f",@total_dia23.to_s)
            row << sprintf("%.1f",@total_dia24.to_s)
            row << sprintf("%.1f",@total_dia25.to_s)
            row << sprintf("%.1f",@total_dia26.to_s)
            row << sprintf("%.1f",@total_dia27.to_s)
            row << sprintf("%.1f",@total_dia28.to_s)
            row << sprintf("%.1f",@total_dia29.to_s)
            row << sprintf("%.1f",@total_dia30.to_s)
            row << sprintf("%.1f",@total_dia31.to_s)
            
            row << sprintf("%.1f",@total_cliente.to_s)

            table_content << row            
          
          
            


        row = []
         row << ""       
         row << " TOTAL GENERAL => "
         
         row << sprintf("%.1f",@total_dia01_column.to_s)
         row << sprintf("%.1f",@total_dia02_column.to_s)
         row << sprintf("%.1f",@total_dia03_column.to_s)
         row << sprintf("%.1f",@total_dia04_column.to_s)
         row << sprintf("%.1f",@total_dia05_column.to_s)
         row << sprintf("%.1f",@total_dia06_column.to_s)
         row << sprintf("%.1f",@total_dia07_column.to_s)
         row << sprintf("%.1f",@total_dia08_column.to_s)
         row << sprintf("%.1f",@total_dia09_column.to_s)
         row << sprintf("%.1f",@total_dia10_column.to_s)
         row << sprintf("%.1f",@total_dia11_column.to_s)
         row << sprintf("%.1f",@total_dia12_column.to_s)
         row << sprintf("%.1f",@total_dia13_column.to_s)
         row << sprintf("%.1f",@total_dia14_column.to_s)
         row << sprintf("%.1f",@total_dia15_column.to_s)
         row << sprintf("%.1f",@total_dia16_column.to_s)
         row << sprintf("%.1f",@total_dia17_column.to_s)
         row << sprintf("%.1f",@total_dia18_column.to_s)
         row << sprintf("%.1f",@total_dia19_column.to_s)
         row << sprintf("%.1f",@total_dia20_column.to_s)
         row << sprintf("%.1f",@total_dia21_column.to_s)
         row << sprintf("%.1f",@total_dia22_column.to_s)
         row << sprintf("%.1f",@total_dia23_column.to_s)
         row << sprintf("%.1f",@total_dia24_column.to_s)
         row << sprintf("%.1f",@total_dia25_column.to_s)
         row << sprintf("%.1f",@total_dia26_column.to_s)
         row << sprintf("%.1f",@total_dia27_column.to_s)
         row << sprintf("%.1f",@total_dia28_column.to_s)
         row << sprintf("%.1f",@total_dia29_column.to_s)
         row << sprintf("%.1f",@total_dia30_column.to_s)
         row << sprintf("%.1f",@total_dia31_column.to_s)
         row << sprintf("%.1f",@total_general.to_s)
         
         table_content << row


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:right
                                          columns([3]).align=:right 
                                          columns([4]).align=:right
                                          columns([5]).align=:right 
                                          columns([6]).align=:right
                                          columns([7]).align=:right 
                                          columns([8]).align=:right
                                          columns([9]).align=:right 
                                          columns([10]).align=:right
                                          columns([11]).align=:right 
                                          columns([12]).align=:right
                                          columns([13]).align=:right 
                                          columns([14]).align=:right 
                                          columns([15]).align=:right
                                          columns([16]).align=:left
                                          columns([17]).align=:right
                                          columns([18]).align=:right 
                                          columns([19]).align=:right
                                          columns([20]).align=:right 
                                          columns([21]).align=:right
                                          columns([22]).align=:right 
                                          columns([23]).align=:right
                                          columns([24]).align=:right 
                                          columns([25]).align=:right
                                          columns([26]).align=:right 
                                          columns([27]).align=:right
                                          columns([28]).align=:right 
                                          columns([29]).align=:right 
                                          columns([30]).align=:right
                                          columns([31]).align=:right
                                          columns([32]).align=:right
                                          
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer_rpt15(pdf)

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
        invoice_headers  = [["Fecha : ",Date.current.in_time_zone ]]    
        invoice_headers
    end

end 