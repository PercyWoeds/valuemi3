
include UsersHelper
include CustomersHelper
include ServicebuysHelper
#include PivotTable 

class CustomerPaymentsController < ApplicationController


  before_filter :authenticate_user!, :checkServices


  def new1

    @company = Company.find(params[:company_id])
    @customerpayments =CustomerPayment.all 

    @customerpayment = CustomerPayment.new

    @customerpayment[:code]="#{generate_guid8()}"  
    @customerpayment[:processed] = false
      
    @company = Company.find(params[:company_id])
    @customerpayment.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @ac_user = getUsername()
    @customerpayment[:user_id] = getUserId()

  
  end 
  


  def registrar
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @customerpayment = CustomerPayment.new

    @customerpayment[:code]="#{generate_guid8()}"  
    @customerpayment[:processed] = false
      
    @company = Company.find(params[:company_id])
    @customerpayment.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @ac_user = getUsername()
    @customerpayment[:user_id] = getUserId()

    @lcCliente = params[:customer_id]


    @pagetitle = "Agrega facturas "

    @mines =  Factura.where(["balance > 0  and customer_id = ?",  @lcCliente ]).first 

    $minesid= @mines.customer_id
    @guias =  @mines.get_facturas($minesid)
    
   end

 
  def build_pdf_header(pdf)

    
      pdf.image "#{Dir.pwd}/public/images/logo2.png", :width => 270
        
      pdf.move_down 6
        
      pdf.move_down 4
      #pdf.text customer.street, :size => 10
      #pdf.text customer.district, :size => 10
      #pdf.text customer.city, :size => 10
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "LIQUIDACION DE COBRANZA", :align => :center
          pdf.text "#{@customerpayment.code}", :align => :center,
                                 :style => :bold
          
        end
      end
      pdf.move_down 10
      pdf 
  end   

  def build_pdf_body(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8        
    pdf.text $lcEntrega5 << " " << $lcEntrega6
          
      headers = []
      table_content = []

      CustomerPayment::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      row=[]
      row<< " "
      row<< @customerpayment.get_document(@customerpayment.document_id)    
      row<< @customerpayment.documento    
      row<< " " 
      row<< " "
      row<< @customerpayment.total.to_s 
      $lcDeposito =sprintf("%.2f",@customerpayment.total.to_s) 
      table_content << row     


       for  product in @customerpayment.get_payments() 
            row = []
            row << nroitem.to_s          
            row << " "            
            row << product.code
            row << product.get_customer(product.customer_id)
            row << product.factory.to_s
            row << product.total.to_s

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
                                          columns([4]).align=:right 
                                          columns([5]).align=:right 
                                        end

      pdf.move_down 10  
      pdf

    end


    def build_pdf_footer(pdf)

   $lcAccount= @customerpayment.bank_acount.number
   $lcBanco =@customerpayment.get_banco(@customerpayment.bank_acount.bank_id)  
   $lcCheque =@customerpayment.get_document(@customerpayment.document_id)+ "-"+@customerpayment.documento    
   

   $lcFactory  = sprintf("%.2f",@customerpayment.get_customer_payment_value("factory").round(2).to_s)  

      data0 = [[" "," "," "," ","TOTALES DEPOSITO => ",$lcDeposito ],
               [" "," "," "," ","COMISION FACTORY => ",$lcFactory],
               [" "," "," "," ","AJUSTE REDONDEDO => ","0.00"] ]

      data =[  ["BANCO","NRO.CUENTA","OPERACION :","GIRADO :","MONEDA : ","T/C."],
               [$lcBanco,$lcAccount,$lcCheque,$lcFecha1,$lcMon,"0.00"]]

            
        pdf.move_down 150
        pdf.text " "
        pdf.table(data0,:cell_style=> {:border_width=>0, :width=> 90,:height => 20 })
            
        pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1, :width=> 90,:height => 20 })
            pdf.move_down 10          
          
        pdf.text ""
        pdf.text "" 
        pdf.text "CONCEPTO : #{@customerpayment.descrip}", :size => 8, :spacing => 4

        
       data =[ ["Procesado por Finanzas ","V.B.Contador","V.B.Administracion ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          
                  
        pdf.bounding_box([0, 20], :width => 538, :height => 50) do        
        pdf.draw_text "Company: #{@customerpayment.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end



  # Export customerpayment to PDF
  def pdf
    @customerpayment = CustomerPayment.find(params[:id])
    company =@customerpayment.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @customerpayment.fecha1.strftime("%d/%m/%Y") 
     $lcMon   = @customerpayment.get_moneda(@customerpayment.bank_acount.moneda_id)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@customerpayment.total)

     $lcDetracion=0
     $lcAprobado= @customerpayment.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@customerpayment.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@customerpayment.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end
  
  # Process an customerpayment
  def do_process

    @customerpayment = CustomerPayment.find(params[:id])
    @customerpayment[:processed] = "1"
    
    @customerpayment.process
    
    flash[:notice] = "The customerpayment order has been processed."
    redirect_to @customerpayment
  end
  # Process an customerpayment
  def do_anular
    @customerpayment = CustomerPayment.find(params[:id])
    @customerpayment[:processed] = "2"
    
    @customerpayment.anular 
    
    flash[:notice] = "The customerpayment order has been anulado."
    redirect_to @customerpayment
  end
  
  # Do send customerpayment via email
  def do_email
    @customerpayment = CustomerPayment.find(params[:id])
    @email = params[:email]
    
    Notifier.customerpayment(@email, @customerpayment).deliver
      
    flash[:notice] = "The customerpayment has been sent successfully."
    redirect_to "/customerpayments/#{@customerpayment.id}"
  end

  
  # Send customerpayment via email
  def email
    @customerpayment = CustomerPayment.find(params[:id])
    @company = @customerpayment.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    @total_pago=0
    @diferencia_pago=0
    @importe_total=0
    

    i = 0

    for item in items
      if item != ""
 
        
        parts = item.split("|BRK|")        
        id = parts[0]        
        cantidad = parts[1]       
        price = parts[2]         


        product = Factura.find(id.to_i)
        product[:tax] = i        
        product[:subtotal] = price.to_f
        product[:pago] =cantidad.to_f

        factory = product[:pago]
        total   = product[:subtotal]

        product[:total] = total

        @total_pago = @total_pago + total       

        @products.push(product)

      end
      
      i += 1
   end
    
    render :layout => false
  end
  

  # Autocomplete for documents
  def ac_documentos
    @docs = Factura.where(["company_id = ? AND (code LIKE ? )", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  # Autocomplete for products
  def ac_customers
    @customer = customer.where(["company_id = ? AND (ruc LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])   
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
  
  # Show customerpayments for a company
  
  def list_customerpayments
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - customerpayments"
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
      if(params[:ac_documentos] and params[:ac_documentos] != "")
        @customer = customer.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_customer].strip})
        
        if @customer
          @customerpayments = customerpayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any customerpayments for that customer."
          redirect_to "/companies/customerpayments/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @customerpayments = CustomerPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any customerpayments for that customer."
          redirect_to "/companies/customerpayments/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @customerpayments = CustomerPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @customerpayments = CustomerrPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @customerpayments = CustomerPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @customerpayments = CustomerPayment.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @customerpayments = CustomerPayment.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /customerpayments
  # GET /customerpayments.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'customerpayments'
    @pagetitle = "customerpayments"
  end

  # GET /customerpayments/1
  # GET /customerpayments/1.xml
  def show
    @customerpayment = CustomerPayment.find(params[:id])

    @company = Company.find(@customerpayment.company_id)

    
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()

        
  end

  # GET /customerpayments/new
  # GET /customerpayments/new.xml
  
  def new
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    @customerpayment = CustomerPayment.new
    @customerpayment[:code]="#{generate_guid8()}"  
    @customerpayment[:processed] = false
      
    @company = Company.find(params[:company_id])
    @customerpayment.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @ac_user = getUsername()
    @customerpayment[:user_id] = getUserId()
  end

  # GET /customerpayments/1/edit
  def edit
    @pagetitle = "Edit customerpayment"
    @action_txt = "Update..."
    
    @customerpayment = CustomerPayment.find(params[:id])
    @company = @customerpayment.company
    @ac_customer = @customerpayment.customer.name
    @ac_user = @customerpayment.user.username
    @customers = @company.get_customers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()
     
    @products_lines = @customerpayment.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /customerpayments
  # POST /customerpayments.xml
  def create
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @customerpayment = CustomerPayment.new(customerpayment_params)    
    @company = Company.find(params[:customer_payment][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @customerpayment.processed='1'
        
    @customerpayment.user_id=@current_user.id 

    respond_to do |format|
      if @customerpayment.save
        # Create products for kit
        @customerpayment.add_products(items)
        
        # Check if we gotta process the customerpayment
        @customerpayment.process()
        @customerpayment.correlativo()              
        
        format.html { redirect_to(@customerpayment, :notice => 'customerpayment was successfully created.') }
        format.xml  { render :xml => @customerpayment, :status => :created, :location => @customerpayment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customerpayment.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /customerpayments/1
  # PUT /customerpayments/1.xml
  def update
    @pagetitle = "Editar Orden"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @customerpayment = CustomerPayment.find(params[:id])
    @company = @customerpayment.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @customerpayment.customer.name
    end
    
    @products_lines = @customerpayment.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @payments = @company.get_payments()
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    
    @customerpayment[:subtotal] = @customerpayment.get_subtotal(items)
    @customerpayment[:tax] = @customerpayment.get_tax(items, @customerpayment[:customer_id])
    @customerpayment[:total] = @customerpayment[:subtotal] + @customerpayment[:tax]

    respond_to do |format|
      if @customerpayment.update_attributes(params[:customerpayment])
        # Create products for kit
        @customerpayment.delete_products()
        @customerpayment.add_products(items)
        
        # Check if we gotta process the customerpayment
        @customerpayment.process()
        
        format.html { redirect_to(@customerpayment, :notice => 'customerpayment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customerpayment.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /customerpayments/1
  # DELETE /customerpayments/1.xml
  def destroy
    @customerpayment = CustomerPayment.find(params[:id])
    company_id = @customerpayment[:company_id]
    
    @customerpayment.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/customer_payments/" + company_id.to_s) }
    end
  end

  def client_data_headers

    #{@customerpayment.description}
      client_headers  = [["Proveedor :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]      
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha Compro. : ",$lcFecha1]]
      invoice_headers <<  ["Tipo de moneda : ", $lcMon]    
      invoice_headers
  end

  def invoice_summary
      invoice_summary = []
      invoice_summary << ["RECIBI CONFORME ",""]
      invoice_summary << ["Fecha  :",""]
      invoice_summary << ["D.N.I. :","Firma"]
      invoice_summary << ["Nombre y Apellidos :",""]
      invoice_summary
  end



  # Export customerpayment to PDF
  def rpt_facturas_all
    @company=Company.find(params[:id])      
        
    if(params[:year] and params[:year].numeric?)
      @year = params[:year].to_i
    else
      @year = Time.now.year
    end
    
    if(params[:month] and params[:month].numeric?)
      @month = params[:month].to_i
    else
      @month = Time.now.month
    end
    

    @facturas_all_rpt = @company.get_facturas_year_month(@year,@month)  
    
    @rpt = "rpt_#{generate_guid()}"

    Prawn::Document.generate("app/pdf_output/#{@rpt}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)        
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/#{@rpt}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

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

  # reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 6
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
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
    
    pdf.text "Pendientes de Pago    Emitidas : Año "+@year.to_s+ " Mes : "+@month.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      CustomerPayment::TABLE_HEADERS1.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

       for  product in @facturas_all_rpt
            row = []
            row << nroitem.to_s
            row << product.date1.strftime("%d/%m/%Y")
            row << product.date2.strftime("%d/%m/%Y")
            row << product.date3.strftime("%d/%m/%Y")
            row << product.payment.day 
            row << product.document.descripshort 
            row << product.documento
            row << product.customer.name  
            row << product.total_amount.to_s            
            row << product.charge.to_s      
            row << product.pago.to_s      
            row << product.balance.to_s            
            table_content << row

            nroitem=nroitem + 1
            puts nroitem 
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
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer_rpt(pdf)

        subtotals = []
        taxes = []
        totals = []
        services_subtotal = 0
        services_tax = 0
        services_total = 0
          
        total = @company.get_services_year_month_value(@year,@month, "total_amount")
        totals.push(total)
        services_total += total
        
        pdf.text total.to_s
        
        
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


  # Export serviceorder to PDF
  def rpt_serviceorder_all_pdf
    @company=Company.find(params[:id])      
    
    
    if(params[:year] and params[:year].numeric?)
      @year = params[:year].to_i
    else
      @year = Time.now.year
    end
    
    if(params[:month] and params[:month].numeric?)
      @month = params[:month].to_i
    else
      @month = Time.now.month
    end
    

    @serviceorder_rpt = @company.get_services_year_month(@year,@month)  
      
    Prawn::Document.generate("app/pdf_output/rpt_serviceall.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_serviceall.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end

##-------------------------------------------------------------------------------------
## reporte completo de cobranza 
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt1(pdf)
      pdf.font "Helvetica" , :size => 6
      

     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
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

  def build_pdf_body_rpt1(pdf)
    
    pdf.text "Listado de Cobranza Emitidas : Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0

      CustomerPayment::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

       for  customerpayment_rpt in @customerpayment_rpt

        @fechacobro = customerpayment_rpt.fecha1

        row = []
         row << nroitem.to_s
         row << customerpayment_rpt.code
         row << customerpayment_rpt.fecha1.strftime("%d/%m/%Y")         
         row << customerpayment_rpt.bank_acount.number
         row << customerpayment_rpt.get_banco(customerpayment_rpt.bank_acount.bank_id)   
         row << customerpayment_rpt.get_moneda(customerpayment_rpt.bank_acount.moneda_id)  
         row << customerpayment_rpt.get_document(customerpayment_rpt.document_id)     
         row << customerpayment_rpt.documento     
         row << ""          
         row << customerpayment_rpt.total    

         #table_content << row
         lcId = customerpayment_rpt.id 

        @customerdetails =  customerpayment_rpt.get_payment_dato(lcId)

        if @customerdetails

           for  productItem in  @customerdetails
                
                row = []
                row << nroitem.to_s
                row << ""
                row << "FT"
                row << productItem.code
                row << productItem.fecha.to_s
                row << productItem.customer.ruc       
                row << productItem.customer.name                 
                row << " "
                row << productItem.factory.to_s
                row << productItem.total.to_s      
                
                total_general = total_general +  productItem.total
                total_factory = total_factory +  productItem.factory

                table_content << row

                nroitem=nroitem + 1
             
            end
        end 

       end  

      @total_soles = total_factory
    @total_dolares = total_general

      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTALES => "
      row << sprintf("%.2f",@total_soles.to_s)
      row << sprintf("%.2f",@total_dolares.to_s)                    
      
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
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                        end                                          
      pdf.move_down 10      




      pdf

    end


    def build_pdf_footer_rpt1(pdf)

        subtotals = []
        taxes = []
        totals = []
        services_subtotal = 0
        services_tax = 0
        services_total = 0

        headers2 = []
        table_content2 = []

        CustomerPayment::TABLE_HEADERS4.each do |header|
          cell = pdf.make_cell(:content => header)
          cell.background_color = "FFFFCC"
          headers2 << cell
        end
        table_content2 << headers2
        nroitem = 1
        
        @banks = BankAcount.all

        for banco in @banks

        total1 = @company.get_customer_payments_value(@fecha1,@fecha2,banco.id)  

        if total1>0
                  
          row =[]
          row << nroitem.to_s
          row << banco.number 
          row << sprintf("%.2f",total1.to_s)
          
          nroitem = nroitem + 1

          table_content2 << row
        end   

        end

        

        row = []
        row << nroitem.to_s
        row << "FACTORY"
        row << sprintf("%.2f",@total_soles.to_s)

        table_content2 << row

      result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => 300
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:right 
                                        end                                          
            
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


  # Export cobrar  to PDF

  def rpt_ccobrar4_pdf

    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]

    @customerpayment_rpt = @company.get_customer_payments(@fecha1,@fecha2)  

      
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment.pdf") do |pdf|
        pdf.font "Helvetica"        
        pdf = build_pdf_header_rpt1(pdf)
        pdf = build_pdf_body_rpt1(pdf)
        build_pdf_footer_rpt1(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end

##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt2(pdf)
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

  def build_pdf_body_rpt2(pdf)
    
    if @tipomoneda == 1
       @tipomoneda_name ="DOLARES"  
    else
       @tipomoneda_name ="SOLES "  
    end 
    pdf.text "Resumen Clientes  Moneda : "+@tipomoneda_name  + " Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0



      CustomerPayment::TABLE_HEADERS6.each do |header|
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
      @total_mes01 = 0
      @total_mes02 = 0
      @total_mes03 = 0
      @total_mes04 = 0
      @total_mes05 = 0
      @total_mes06 = 0
      @total_mes07 = 0
      @total_mes08 = 0
      @total_mes09 = 0
      @total_mes10 = 0
      @total_mes11 = 0
      @total_mes12 = 0
      @total_anterior_column = 0
      @total_mes01_column = 0
      @total_mes02_column = 0
      @total_mes03_column = 0
      @total_mes04_column = 0
      @total_mes05_column = 0
      @total_mes06_column = 0
      @total_mes07_column = 0
      @total_mes08_column = 0
      @total_mes09_column = 0
      @total_mes10_column = 0
      @total_mes11_column = 0
      @total_mes12_column = 0
      


      lcCli = @customerpayment_rpt.first.customer_id
      $lcCliName = ""
    

     for  customerpayment_rpt in @customerpayment_rpt

        if lcCli == customerpayment_rpt.customer_id 

          $lcCliName = customerpayment_rpt.customer.name  
      
          if customerpayment_rpt.year_month.to_f <= 201612
            @total_anterior = @total_anterior + customerpayment_rpt.balance.round(2)          
          end             

          if customerpayment_rpt.year_month == '201701'
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance.round(2)        
          end   

          if customerpayment_rpt.year_month == '201702' 
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance.round(2)        
          end 
            
          if customerpayment_rpt.year_month == '201703'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201704'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201705'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201706'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201707' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201708'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201709'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201710'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201711'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201712'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance.round(2)        
          end   
        else

          if customerpayment_rpt.year_month.to_f <= 201612
            @total_anterior = @total_anterior + customerpayment_rpt.balance.round(2)          
          end             

          if customerpayment_rpt.year_month == '201701'
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance.round(2)        
          end   

          if customerpayment_rpt.year_month == '201702' 
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance.round(2)        
          end 
            
          if customerpayment_rpt.year_month == '201703'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201704'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201705'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201706'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201707' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201708'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201709'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201710'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201711'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201712'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance.round(2)        
          end   


            @total_cliente = @total_anterior+
            @total_mes01+
            @total_mes02+
            @total_mes03+
            @total_mes04+
            @total_mes05+
            @total_mes06+
            @total_mes07+
            @total_mes08+
            @total_mes09+
            @total_mes10+
            @total_mes11+
            @total_mes12
            
            row = []
            row << nroitem.to_s        
            row << $lcCliName
            row << sprintf("%.2f",@total_anterior.to_s)
            row << sprintf("%.2f",@total_mes01.to_s)
            row << sprintf("%.2f",@total_mes02.to_s)
            row << sprintf("%.2f",@total_mes03.to_s)
            row << sprintf("%.2f",@total_mes04.to_s)
            row << sprintf("%.2f",@total_mes05.to_s)
            row << sprintf("%.2f",@total_mes06.to_s)
            row << sprintf("%.2f",@total_mes07.to_s)
            row << sprintf("%.2f",@total_mes08.to_s)
            row << sprintf("%.2f",@total_mes09.to_s)
            row << sprintf("%.2f",@total_mes10.to_s)
            row << sprintf("%.2f",@total_mes11.to_s)
            row << sprintf("%.2f",@total_mes12.to_s)
            row << sprintf("%.2f",@total_cliente.to_s)

            table_content << row            
            ## TOTAL XMES GENERAL
            @total_anterior_column = @total_anterior_column + @total_anterior
            @total_mes01_column = @total_mes01_column +@total_mes01
            @total_mes02_column = @total_mes02_column +@total_mes02
            @total_mes03_column = @total_mes03_column +@total_mes03
            @total_mes04_column = @total_mes04_column +@total_mes04
            @total_mes05_column = @total_mes05_column +@total_mes05
            @total_mes06_column = @total_mes06_column +@total_mes06
            @total_mes07_column = @total_mes07_column +@total_mes07
            @total_mes08_column = @total_mes08_column +@total_mes08
            @total_mes09_column = @total_mes09_column +@total_mes09
            @total_mes10_column = @total_mes10_column +@total_mes10
            @total_mes11_column = @total_mes11_column +@total_mes11
            @total_mes12_column = @total_mes12_column +@total_mes12
            @total_cliente = 0 
            ## TOTAL XMES GENERAL

            $lcCliName =customerpayment_rpt.customer.name

            lcCli = customerpayment_rpt.customer_id
        
            @total_anterior = 0
            @total_mes01 = 0
            @total_mes02 = 0
            @total_mes03 = 0
            @total_mes04 = 0
            @total_mes05 = 0
            @total_mes06 = 0
            @total_mes07 = 0
            @total_mes08 = 0
            @total_mes09 = 0
            @total_mes10 = 0
            @total_mes11 = 0
            @total_mes12 = 0
            @total_cliente = 0 

          nroitem = nroitem + 1 



        end 
         @total_general = @total_general + customerpayment_rpt.balance.round(2)
       end   

      #fin for
          #ultimo cliente 

          @total_cliente = @total_anterior+
          @total_mes01+
          @total_mes02+
          @total_mes03+
          @total_mes04+
          @total_mes05+
          @total_mes06+
          @total_mes07+
          @total_mes08+
          @total_mes09+
          @total_mes10+
          @total_mes11+
          @total_mes12
            @total_anterior_column = @total_anterior_column + @total_anterior
            @total_mes01_column = @total_mes01_column +@total_mes01
            @total_mes02_column = @total_mes02_column +@total_mes02
            @total_mes03_column = @total_mes03_column +@total_mes03
            @total_mes04_column = @total_mes04_column +@total_mes04
            @total_mes05_column = @total_mes05_column +@total_mes05
            @total_mes06_column = @total_mes06_column +@total_mes06
            @total_mes07_column = @total_mes07_column +@total_mes07
            @total_mes08_column = @total_mes08_column +@total_mes08
            @total_mes09_column = @total_mes09_column +@total_mes09
            @total_mes10_column = @total_mes10_column +@total_mes10
            @total_mes11_column = @total_mes11_column +@total_mes11
            @total_mes12_column = @total_mes12_column +@total_mes12
          
            row = []
            row << nroitem.to_s        
            row << customerpayment_rpt.customer.name  
            row << sprintf("%.2f",@total_anterior.to_s)
            row << sprintf("%.2f",@total_mes01.to_s)
            row << sprintf("%.2f",@total_mes02.to_s)
            row << sprintf("%.2f",@total_mes03.to_s)
            row << sprintf("%.2f",@total_mes04.to_s)
            row << sprintf("%.2f",@total_mes05.to_s)
            row << sprintf("%.2f",@total_mes06.to_s)
            row << sprintf("%.2f",@total_mes07.to_s)
            row << sprintf("%.2f",@total_mes08.to_s)
            row << sprintf("%.2f",@total_mes09.to_s)
            row << sprintf("%.2f",@total_mes10.to_s)
            row << sprintf("%.2f",@total_mes11.to_s)
            row << sprintf("%.2f",@total_mes12.to_s)
            row << sprintf("%.2f",@total_cliente.to_s)

            table_content << row            
            


        row = []
         row << ""       
         row << " TOTAL GENERAL => "
         row << sprintf("%.2f",@total_anterior_column.to_s)
         row << sprintf("%.2f",@total_mes01_column.to_s)
         row << sprintf("%.2f",@total_mes02_column.to_s)
         row << sprintf("%.2f",@total_mes03_column.to_s)
         row << sprintf("%.2f",@total_mes04_column.to_s)
         row << sprintf("%.2f",@total_mes05_column.to_s)
         row << sprintf("%.2f",@total_mes06_column.to_s)
         row << sprintf("%.2f",@total_mes07_column.to_s)
         row << sprintf("%.2f",@total_mes08_column.to_s)
         row << sprintf("%.2f",@total_mes09_column.to_s)
         row << sprintf("%.2f",@total_mes10_column.to_s)
         row << sprintf("%.2f",@total_mes11_column.to_s)
         row << sprintf("%.2f",@total_mes12_column.to_s)
         row << sprintf("%.2f",@total_general.to_s)
         
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
                                          
                                        end                                          
      pdf.move_down 10      




      pdf

    end


    def build_pdf_footer_rpt2(pdf)

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


  def rpt_ccobrar5_pdf

    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @tipomoneda = params[:moneda_id]

    @company.actualizar_fecha2
    @company.actualiza_monthyear
    @customerpayment_rpt = @company.get_customer_payments2(@tipomoneda)
      
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment2.pdf") do |pdf|        

        pdf.start_new_page(:size => "A4", :layout => :landscape)
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment2.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

##
## RESUMEN DE INGRESO A BANCOS 
##
##-------------------------------------------------------------------------------------
## reporte completo de cobranza 
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt3(pdf)
      pdf.font "Helvetica" , :size => 6
      

     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
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

  def build_pdf_body_rpt3(pdf)
    
    pdf.text "RESUMEN DE INGRESOS : Desde "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 11 ,:align => :center
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0
        headers2 = []
        table_content2 = []

        CustomerPayment::TABLE_HEADERS5.each do |header|
          cell = pdf.make_cell(:content => header)
          cell.background_color = "FFFFCC"
          headers2 << cell
        end
        table_content2 << headers2
        nroitem = 1
        
        @banks = BankAcount.all
        @total_general = 0

        for banco in @banks

        total1 = @company.get_customer_payments_value(@fecha1,@fecha2,banco.id)  

        if total1>0
                  
          row =[]
          row << nroitem.to_s
          row << banco.number 
          row << sprintf("%.2f",total1.to_s)
          
          nroitem = nroitem + 1
          @total_general = @total_general + total1

          table_content2 << row
        end   

        end

        @total_soles = @company.get_customer_payments_value_otros(@fecha1,@fecha2,"factory") 
        row = []
        row << nroitem.to_s
        row << "FACTORY"
        row << sprintf("%.2f",@total_soles.to_s)

        table_content2 << row
        @total_general = @total_general + total1

        
          row =[]
          row << " "
          row << "TOTAL GENERAL => "
          row << sprintf("%.2f",@total_general.to_s)
          table_content2 << row
          result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => 300
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:right 
                                        end                                          
      

          pdf.text "" 
          pdf 


      
    end


    def build_pdf_footer_rpt3(pdf)

      
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


  # Export cobrar  to PDF



  def rpt_ccobrar6_pdf

    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]


    @customerpayment_rpt = @company.get_customer_payments(@fecha1,@fecha2)  

      
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment.pdf") do |pdf|
        pdf.font "Helvetica"        
        pdf = build_pdf_header_rpt3(pdf)
        pdf = build_pdf_body_rpt3(pdf)
        build_pdf_footer_rpt3(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end





##
##FIN RESUMEN INGRESO A BANCOS 
##

  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end

 
  private
  def customerpayment_params
    params.require(:customer_payment).permit(:company_id,:location_id,:division_id,:bank_acount_id,
      :document_id,:documento,:customer_id,:tm,:total,:fecha1,:fecha2,:nrooperacion,:operacion,
      :descrip,:comments,:user_id,:processed,:code,:concept_id)

  end

end

