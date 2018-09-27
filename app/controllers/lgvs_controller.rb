include UsersHelper
include CustomersHelper
include ProductsHelper

class LgvsController < ApplicationController
    
    before_filter :authenticate_user!, :checkProducts
 ###
 # reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.zone.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
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

  def build_pdf_body_rpt(pdf)
    
    pdf.text "Listado de Vueltos " +" Emitidas : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 


    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Lgv::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      t_devuelto  = 0
      t_reembolso = 0
      t_descuento = 0

       for  a in @lgv_rpt 
       
            row = []          
             row << a.compro.tranportorder.code
             row << a.compro.tranportorder.employee.full_name
             lcRuta =  a.compro.tranportorder.truck.placa << " - " << a.compro.tranportorder.get_placa(a.compro.tranportorder.truck2_id)
             row << lcRuta 
             lcPunto2 = a.compro.tranportorder.get_punto(a.compro.tranportorder.ubication_id) << " Hasta "<< a.compro.tranportorder.get_punto(a.compro.tranportorder.ubication2_id)
             row <<  lcPunto2
             row << a.compro.tranportorder.fecha1.strftime("%d/%m/%Y")
             row << a.compro.tranportorder.fecha2.strftime("%d/%m/%Y")
             row << a.lgv.devuelto.to_s
             row << a.lgv.reembolso.to_s
             row << a.lgv.descuento.to_s
              t_devuelto  += a.lgv.devuelto
              t_reembolso += a.lgv.reembolso
              t_descuento += a.lgv.descuento
             
             
            lcRuta=""
            lcPunto2=""
            table_content << row

            nroitem=nroitem + 1
       
        end



      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTALES => "
      row << ""
      row << t_devuelto
      row << t_reembolso
      row << t_descuento
      
      table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:right  
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      

      #totales 

      pdf 

    end

    def build_pdf_footer_rpt(pdf)
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end
 def rpt_lgv2_pdf
   


    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    

    @lgv_rpt = @company.get_lgvs3(@fecha1,@fecha2)      

#    respond_to do |format|
#      format.html    
#      format.xls # { send_data @products.to_csv(col_sep: "\t") }
#    end 

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end
 
 ###
 
  def build_pdf_header(pdf)
    
      pdf.image "#{Dir.pwd}/public/images/logo2.png", :width => 270        
      pdf.move_down 6        
      pdf.move_down 4
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "LIQUIDACION GASTOS DE VIAJE", :align => :center
          pdf.text "#{@lgv.code}", :align => :center,
                                 :style => :bold
          
        end
      end
       
      
      pdf 
  end   

  def build_pdf_body(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8        
    
     
       a= @lgv.get_lgvs2.first
    
       $lcCli = a.compro.tranportorder.code
       $lcdir1 = a.compro.tranportorder.employee.full_name
       $lcPlaca = a.compro.tranportorder.truck.placa << " - " << a.compro.tranportorder.get_placa(a.compro.tranportorder.truck2_id)
       
       $lcPunto2=  a.compro.tranportorder.get_punto(a.compro.tranportorder.ubication2_id)
       $lcPunto =  a.compro.tranportorder.get_punto(a.compro.tranportorder.ubication_id) << " Hasta "<< $lcPunto2
       $lcFecha = a.compro.tranportorder.fecha1.strftime("%d/%m/%Y")
       $lcFecha2 = a.compro.tranportorder.fecha2.strftime("%d/%m/%Y")
       
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
  
          pdf.move_down 18
  
        end
      headers = []
      table_content = []

      Lgv::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
       
      table_content << headers
      
       nroitem=1 
       row = []
       row << nroitem.to_s 
       row << "  "
       row << "PEAJE ...."
       
         row << "  "
         row << "  "
         row << "  "
         row << "MTC "
         row << "  "
         row << @lgv.peaje 
         
         table_content << row
  
      nroitem = nroitem + 1
       

        
        
        for  product in @lgv.get_lgvs() 
            row = []
            row << nroitem.to_s 
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.gasto.grupo 
            row << product.gasto.code
            row << product.gasto.descrip
            row << product.td
            row << product.documento
            
#              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
            row << " "
          row << product.total
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
                                          columns([5]).align=:right 
                                          columns([6]).align=:right 
                                          columns([7]).align=:left  
                                          columns([8]).align=:right 
                                    
                                        end
      pdf.move_down 18
      headers2 = []
      table_content2 = []
      
      Lgv::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers2 << cell
      end
      
      table_content2 << headers2
      por_rendir = 0
       
        for  product in @lgv.get_lgvs2() 
            row = []
            row  <<  "VIATICOS "
            row  <<  product.compro.code
            row  <<  product.importe
            por_rendir += product.importe.to_f  
            table_content2 << row
            nroitem=nroitem + 1      
        end
        
        row = []
        row  <<  "TOTAL A RENDIR: "
        row  <<  " "
        row  <<  por_rendir
      
        table_content2 << row
        
        result = pdf.table table_content2, {
                                        :position => :right,
                                        :cell_style => {:border_width => 1},
                                        :width => pdf.bounds.width/2
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left 
                                          columns([2]).align=:left                                          
                                          columns([3]).align=:right  
                                 
                                    
                                        end
       
    
      
      pdf.move_down 20  
     
     $lcIngreso   = sprintf("%.2f",@lgv.total_ing.round(2).to_s)  
     $lcEgreso    = sprintf("%.2f",@lgv.total_egreso.round(2).to_s)  
     $lcSaldo     = sprintf("%.2f",@lgv.saldo.round(2).to_s)  
     
     $lcCDevuelto  = @lgv.cdevuelto
     $lcCReembolso = @lgv.creembolso
     $lcCDescuento = @lgv.cdescuento

     $lcDevuelto  = sprintf("%.2f",@lgv.devuelto.round(2).to_s)  
     $lcReembolso = sprintf("%.2f",@lgv.reembolso.round(2).to_s)  
     $lcDescuento = sprintf("%.2f",@lgv.descuento.round(2).to_s)  

     
      
      headers3 = []
      table_content3 = []
      
      Lgv::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers3 << cell
      end
      
      table_content3 << headers3

        row = []
        row  <<  "GASTOS REALIZADOS : "
        row  <<  " "
        row  <<  $lcEgreso
        table_content3 << row
        row = []
        row  <<  "VUELTO: "
        row  <<  $lcCDevuelto
        row  <<  $lcDevuelto
        table_content3 << row
        row = []
        row  <<  "DESCUENTO: "
        row  <<  $lcCDescuento
        row  <<  $lcDescuento
        table_content3 << row
        row = []
        row  <<  "REEMBOLSO: "
        row  <<  $lcCReembolso
        row  <<  $lcReembolso
        table_content3 << row
        
        
        
        result = pdf.table table_content3, {
                                        :position => :right,
                                        :cell_style => {:border_width => 1},
                                        :width => pdf.bounds.width/2
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left 
                                          columns([2]).align=:left                                          
                                          columns([3]).align=:right
                                 
                                    
                                        end
       
    
      pdf.move_down 10  
      
      pdf
    end


    def build_pdf_footer(pdf)
      
    
        pdf.text ""
        pdf.text "" 
        pdf.text "OBSERVACIONES : #{@lgv.comments}", :size => 8, :spacing => 4

        
       data =[ ["Procesado Asis.Finanzas ","V.B.Contador","V.B.Administracion ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          
                  
        pdf.bounding_box([0, 20], :width => 538, :height => 50) do        
        pdf.draw_text "Company: #{@lgv.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end   
     
  # Export lgv to PDF

  def pdf
    @lgv  =Lgv.find(params[:id])
    company =@lgv.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @lgv.fecha.strftime("%d/%m/%Y") 
     $lcMon   = @lgv.get_moneda(1)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@lgv.inicial)

     $lcDetracion=0
     $lcAprobado= @lgv.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@lgv.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@lgv.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end
  
  def client_data_headers
      client_headers  = [["O-ST N°  :", $lcCli ]]
      client_headers << ["Conductor :", $lcdir1]
      client_headers << ["Placa :", $lcPlaca]
      client_headers
  end

  def invoice_headers          
    
      invoice_headers  = [["Desde : ",$lcPunto]]
      invoice_headers << ["Fecha Salida  :", $lcFecha]
      invoice_headers << ["Fecha Llegada :", $lcFecha2]
      invoice_headers
  end
  
  # Process an lgv
  def do_process
    @lgv = Lgv.find(params[:id])
    @lgv[:processed] = "1"
    
    @lgv.process
    
    flash[:notice] = "The lgv order has been processed."
    redirect_to @lgv
  end
  
  # Do send lgv via email
  def do_email
    @lgv = Lgv.find(params[:id])
    @email = params[:email]
    
    Notifier.lgv(@email, @lgv).deliver
    
    flash[:notice] = "The lgv has been sent successfully."
    redirect_to "/lgvs/#{@lgv.id}"
  end

  
  # Send lgv via email
  def email
    @lgv = Lgv.find(params[:id])
    @company = @lgv.company
  end
  
  # List items
  def list_items
    
   
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    
    @products = []
    @total_pago1= 0
    @diferencia = 0
    
    i = 0
    total = 0 
    diferencia = 0
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")
         
        id = parts[0]
        fecha = parts[1]
        td = parts[2]
        documento = parts[3]
        importe  = parts[4]
        peaje    = parts[5].to_f
        monto_inicial = parts[6].to_f 
        
        product = Gasto.find(id.to_i)
        product[:i] = i
        product[:fecha] = fecha
        product[:td] = td
        product[:documento] = documento
        product[:importe] = importe.to_f
        
        total += product[:importe]
        
        product[:currtotal] = total
        
        @total_pago1  = total     
        if $total_inicial != nil
          
          @diferencia = $total_inicial -  total - peaje
        else
          $total_inicial = 0 
          @diferencia = $total_inicial -  total - peaje 
        end
        
        
        @products.push(product)
        
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  
   def list_items2
    
    @company = Company.find(params[:company_id])
    items = params[:items2]
    items = items.split(",")
    items_arr = []
    @lgvs = []
    i = 0
    @total_inicial = 0
    total = 0 
    monto_inicial = 0
    $total_inicial= 0
    for item in items
      if item != ""
        parts = item.split("|BRK|")

        id      = parts[0]  
        monto_inicial = parts[1]
        
        product = Compro.find(id.to_i)
        
        product[:i] = i
        product[:importe] = monto_inicial.to_f
        product[:detalle] = product.tranportorder.employee.full_name 
        product[:descrip] = product.tranportorder.truck.placa 
        
        total += product[:importe]
        
        @total_inicial  = total     
        
        @diferencia = 
        
        @lgvs.push(product)

      end
      
      $total_inicial= @total_inicial
      i += 1
    end

    render :layout => false
  end 



  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end
  
  # Autocomplete for documento
  def ac_documentos
    @products = Gasto.where(["company_id = ? AND code LIKE ?", params[:company_id], "%" + params[:q] + "%"])
    
    render :layout => false
  end
  # Autocomplete for compro
  def ac_compros
    @compros = Compro.where(["company_id = ? AND code LIKE ?", params[:company_id], "%" + params[:q] + "%"])
    
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end
   
    render :layout => false
  end
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show lgvs for a company
  def list_lgvs
    @company = Company.find(1)
    @pagetitle = "#{@company.name} - lgvs"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(current_user))
         @lgvs = Lgv.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @lgvs = Lgv.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @lgvs = Lgv.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /lgvs
  # GET /lgvs.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'lgvs'
    @pagetitle = "lgvs"
  end

  # GET /lgvs/1
  # GET /lgvs/1.xml
  def show
    @lgv = Lgv.find(params[:id])
  end

  # GET /lgvs/new
  # GET /lgvs/new.xml

  
  
  def new
    @pagetitle = "Nueva LGV."
    @action_txt = "Create"
    
    @lgv = Lgv.new
    @lgv[:code] = "#{generate_guid_lgv()}"
    @lgv[:processed] = "0"
    $total_inicial = 0 
    @company = Company.find(params[:company_id])
    @lgv.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
     @transports = @company.get_transports()
     @compros = Compro.all 
    @gastos = Gasto.all 
    
    @ac_user = getUsername()
    @lgv[:fecha] = Date.today
    @lgv[:user_id] = getUserId()
  end


  # GET /lgvs/1/edit
  def edit
    @pagetitle = "Edit lgv"
    @action_txt = "Update"
    
    @lgv = Lgv.find(params[:id])
    @company = @lgv.company
    @ac_customer = @lgv.customer.name
    @ac_user = @lgv.user.username
    
    @products_lines = @lgv.products_lines
    @compros_lines= @lgv.compros_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /lgvs
  # POST /lgvs.xml
  def create
    @pagetitle = "New lgv"
    @action_txt = "Create"
     @compros = Compro.all 
     
    items = params[:items].split(",")
    items2 = params[:items2].split(",")
    
    @lgv = Lgv.new(lgv_params)
    
    @company = Company.find(params[:lgv][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @gastos = Gasto.all 
    
    begin
      @lgv[:inicial] = 0
    rescue
      @lgv[:inicial] = 0
    end 
    
    begin
      @lgv[:total_ing] = @lgv.get_total_ing(items2)
    rescue 
      @lgv[:total_ing] = 0
    end 
    begin 
      @lgv[:total_egreso]=  @lgv.get_total_sal(items)
    rescue 
      @lgv[:total_egreso]= 0 
    end 
    @lgv[:saldo] =@lgv[:total_ing] - @lgv[:total_egreso] -@lgv[:peaje]
    
    if(params[:lgv][:user_id] and params[:lgv][:user_id] != "")
      curr_seller = User.find(params[:lgv][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @lgv.save
        # Create products for kit
        @lgv.add_products(items)  
        @lgv.add_products2(items2)  
        # Check if we gotta process the lgv
        @lgv.process()
        
        format.html { redirect_to(@lgv, :notice => 'lgv was successfully created.') }
        format.xml  { render :xml => @lgv, :status => :created, :location => @lgv }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lgv.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /lgvs/1
  # PUT /lgvs/1.xml
  def update
    @pagetitle = "Edit lgv"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @lgv = Lgv.find(params[:id1])
    @company = @lgv.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @lgv.customer.name
    end
    
    @products_lines = @lgv.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @lgv[:subtotal] = @lgv.get_subtotal(items)
    @lgv[:tax] = @lgv.get_tax(items, @lgv[:customer_id])
    @lgv[:total] = @lgv[:subtotal] + @lgv[:tax]


    respond_to do |format|
      if @lgv.update_attributes(params[:lgv])
        # Create products for kit
        @lgv.delete_products()
        @lgv.add_products(items)
        
        # Check if we gotta process the lgv
        @lgv.process()
        
        format.html { redirect_to(@lgv, :notice => 'lgv was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lgv.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lgvs/1
  # DELETE /lgvs/1.xml
  def destroy
    @lgv = Lgv.find(params[:id])
    company_id = @lgv[:company_id]
    @lgv.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/lgvs/" + company_id.to_s) }
    end
  end
  
  private
  def lgv_params
    params.require(:lgv).permit( :code, :fecha, :lgv_id, :total, :devuelto_texto, :devuelto, :reembolso, :descuento, :observa,
 :company_id, :processed, :user_id,  :tranportorder_id, :comments, :gasto_id, :compro_id, :inicial, :total_ing, :total_egreso, :saldo,:peaje,
 :creembolso,:cdescuento,:cdevuelto)
  end

end


