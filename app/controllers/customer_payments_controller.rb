
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
    
      pdf.image "#{Dir.pwd}/public/images/logo.png", :width => 270        
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
      row<< sprintf("%.2f",@customerpayment.total.to_s) 
      $lcDeposito =sprintf("%.2f",@customerpayment.total.to_s) 
      table_content << row     


       for  product in @customerpayment.get_payments() 
            row = []
            row << nroitem.to_s          
            row << " "            
            row << product.code
            row << product.get_customer(product.customer_id)          
            row << sprintf("%.2f",product.factory.to_s)
            row << sprintf("%.2f",product.total.to_s)

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
   $lcAjuste   = sprintf("%.2f",@customerpayment.get_customer_payment_value("ajuste").round(2).to_s)  
   $lcCompen   = sprintf("%.2f",@customerpayment.get_customer_payment_value("compen").round(2).to_s)  

      data0 = [[" "," "," "," ","TOTALES DEPOSITO => ",$lcDeposito ],
               [" "," "," "," ","COMISION FACTORY => ",$lcFactory],
               [" "," "," "," ","COMPENSACION     => ",$lcCompen],
               [" "," "," "," ","AJUSTE REDONDEDO => ",$lcAjuste ] ]

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
        compen    = parts[1]        
        ajuste    = parts[2]        
        cantidad  = parts[3]       
        price     = parts[4]         


        product = Factura.find(id.to_i)
        product[:tax] = i        
        product[:balance]  = compen.to_f
        product[:subtotal] = price.to_f
        product[:pago]     = cantidad.to_f
        product[:charge]   = ajuste.to_f

        compen  = product[:balance]
        ajuste  = product[:charge]
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
    @docs = Factura.where(["company_id = ? and balance<>0 AND (code ILIKE ? )", params[:company_id], "%" + params[:q] + "%"])   
        
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
        @customerpayments = CustomerPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "code DESC")
      elsif(params[:location] and params[:location] != "")
        @customerpayments = CustomerrPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "code DESC")
      elsif(params[:division] and params[:division] != "")
        @customerpayments = CustomerPayment.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "code DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @customerpayments = CustomerPayment.paginate(:page => params[:page], :order => 'code DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else

          @customerpayments = CustomerPayment.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
         #@customerpayments = CustomerPayment.find_by_sql("Select * from Customer_Payments ")
          respond_to do |format|
              format.html
              format.csv { send_data @customerpayments.to_csv }
              
            end         
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
    
    respond_to do |format|
     format.html
     end
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

    items = CustomerPaymentDetail.where(:customer_payment_id => @customerpayment.id)
    for f in items
          importe = f.total
          ajuste = f.ajuste        
          compen =  f.compen
          factura = Factura.find(f.factura_id)            
          #@newbalance= factura.balance + importe -ajuste +compen  cambiado x solicutd andrea 3-6-17
          @newbalance= factura.balance + importe
          factura.balance = @newbalance
          factura.save
          
    end 


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
      total_general_soles = 0
      total_general_dolar = 0
      total_factory = 0

      CustomerPayment::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

       for  productItem in @customerpayment_rpt
          lcId      = productItem.id 
          if $lcxCliente == "0" 
            $lcCode   = productItem.code
          else
            $lcCode   = productItem.code_liq
          end 

         $lcFecha1 = productItem.fecha1.strftime("%d/%m/%Y")                  
         
      
                row = []
                row << nroitem.to_s
                if $lcxCliente == "0" 
                  $lcCode   = productItem.code_liq
                else
                  $lcCode   = productItem.code_liq
                end 
                
                row << $lcCode
                row << $lcFecha1 
                row << "FT"
                row << productItem.code 
                row << productItem.fecha1.strftime("%d/%m/%Y")  
                
                @cliente_obs = productItem.get_cliente(productItem.customer_id)
                
                row << @cliente_obs.ruc
                row << @cliente_obs.name
                if $lcxCliente == "0" 
                  row << " "  
                else
                  row << productItem.factory.to_s
                end 
                
                monedabanco= productItem.get_banco_moneda(productItem.bank_acount_id)
                
                if monedabanco == 2
                  row << productItem.total.to_s
                  row << " "  
                else
                  row << " "  
                  row << productItem.total.to_s
                  
                end


                total_factory = total_factory +  productItem.factory

                if monedabanco == 2
                  total_general_soles = total_general_soles +  productItem.total
                else
                  total_general_dolar = total_general_dolar +  productItem.total
                end 

                table_content << row

                nroitem=nroitem + 1
             
            end
       
    @total_factory = total_factory

    @total_soles = total_general_soles
    @total_dolar = total_general_dolar

      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTALES => "
      row << sprintf("%.2f",@total_factory.to_s)
      row << sprintf("%.2f",@total_soles.to_s)                    
      row << sprintf("%.2f",@total_dolar.to_s)                    
      
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
                                          columns([11]).align=:right
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
        @totalgeneral_soles = 0
        @totalgeneral_dolar = 0
        @totalgeneral  = 0

        if $lcxCliente == "0"

          for banco in @banks

          total1 = @company.get_customer_payments_value(@fecha1,@fecha2,banco.id)  

          if total1>0
                    
            row =[]
            row << nroitem.to_s
            row << banco.number 

              a = BankAcount.find(banco.id)

              if a.moneda_id == 1
                row << " "
                row << sprintf("%.2f",total1.to_s)
                @totalgeneral_dolar = @totalgeneral_dolar + total1 
              else
                row << sprintf("%.2f",total1.to_s)
                row << " "

                @totalgeneral_soles = @totalgeneral_soles + total1 
              end

            nroitem = nroitem + 1
            table_content2 << row
          end   

          end
          $lcFactory = 0
          $lcCompen  = 0
          $lcAjuste  = 0
          
          $lcFactory2 = 0
          $lcCompen2  = 0
          $lcAjuste2  = 0
          
          moneda_ajuste_soles = 2
          moneda_ajuste_dolar = 1

           $lcFactory = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'factory',2)      
           $lcCompen  = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'compen',2)
           $lcAjuste  = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'ajuste',2)
           
           $lcFactory2 = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'factory',1)      
           $lcCompen2  = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'compen',1)
           $lcAjuste2  = @company.get_customer_payments_value_otros_customer2(@fecha1,@fecha2,'ajuste',1)
           
           $lcCompen = $lcCompen*-1
           $lcCompen2 = $lcCompen2*-1
           
           @totalgeneral_soles = @totalgeneral_soles + $lcAjuste2 + $lcFactory2 +$lcCompen2
           @totalgeneral_dolar = @totalgeneral_dolar + $lcAjuste + $lcFactory +$lcCompen
           

           row = []
          row << nroitem.to_s
          row << "FACTORY"
          
          row << sprintf("%.2f",$lcFactory2.to_s)
          row << sprintf("%.2f",$lcFactory.to_s)
          table_content2 << row
          row = []
          row << nroitem.to_s
          row << "COMPENSACION:"
          row << sprintf("%.2f",$lcCompen2.to_s)
          row << sprintf("%.2f",$lcCompen.to_s)
          
          table_content2 << row
          
          row = []
          row << nroitem.to_s
          row << "AJUSTE"
          row << sprintf("%.2f",$lcAjuste2.to_s)
          row << sprintf("%.2f",$lcAjuste.to_s)
          

          table_content2 << row
          row = []
          row << nroitem.to_s
          row << "TOTAL => "
          
          row << sprintf("%.2f",@totalgeneral_soles.to_s)
          row << sprintf("%.2f",@totalgeneral_dolar.to_s)
          

      else
        
          for banco in @banks
          
          total1 = @company.get_customer_payments_value_customer(@fecha1,@fecha2,banco.id,@cliente,"total")  

          if total1>0 and total1 != nil
                    
            row =[]
            row << nroitem.to_s
            row << banco.number 
            row << sprintf("%.2f",total1.to_s)
            if banco.moneda_id == 2
              @totalgeneral_soles = @totalgeneral_soles + total1 
            else
              @totalgeneral_dolar = @totalgeneral_dolar + total1 
            end 
            nroitem = nroitem + 1
            table_content2 << row
          else
            total1 = 0
            if banco.moneda_id == 2
              @totalgeneral_soles = @totalgeneral_soles + total1 
            else
              @totalgeneral_dolar = @totalgeneral_dolar + total1 
            end 
          end   

          end
          $lcFactory = 0
          $lcCompen  = 0
          $lcAjuste  = 0
          
          moneda_ajuste_soles = 2
          moneda_ajuste_dolar = 1
            
           $lcFactory = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'factory',@cliente,moneda_ajuste_soles)      
           $lcCompen  = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'compen',@cliente,moneda_ajuste_soles)
           $lcAjuste  = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'ajuste',@cliente,moneda_ajuste_soles)
           
           $lcFactory2 = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'factory',@cliente,moneda_ajuste_dolar)      
           $lcCompen2  = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'compen',@cliente,moneda_ajuste_dolar)
           $lcAjuste2  = @company.get_customer_payments_value_otros_customer(@fecha1,@fecha2,'ajuste',@cliente,moneda_ajuste_dolar)
           

           @totalgeneral_soles = @totalgeneral_soles + $lcAjuste2 + $lcFactory2 +$lcCompen2
           @totalgeneral_dolar = @totalgeneral_dolar + $lcAjuste + $lcFactory +$lcCompen 
           
          row = []
          row << nroitem.to_s
          row << "FACTORY"
          row << sprintf("%.2f",$lcFactory2.to_s)
          row << sprintf("%.2f",$lcFactory.to_s)
          
          
          table_content2 << row
          row = []
          row << nroitem.to_s
          row << "COMPENSACION:"
          row << sprintf("%.2f",$lcCompen2.to_s)
          row << sprintf("%.2f",$lcCompen.to_s)
          
          table_content2 << row
          
          row = []
          row << nroitem.to_s
          row << "AJUSTE"
          row << sprintf("%.2f",$lcAjuste2.to_s)
          row << sprintf("%.2f",$lcAjuste.to_s)
          

          table_content2 << row
          row = []
          row << nroitem.to_s
          row << "TOTAL => "

          row << sprintf("%.2f",@totalgeneral_soles.to_s)
          
          row << sprintf("%.2f",@totalgeneral_dolar.to_s)
        
            

      end 

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
    $lcxCliente = "0"
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

  def rpt_ccobrar7_pdf
    $lcxCliente = "1"
    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]
    
    @ClienteDato = @company.get_cliente(@cliente)
    $lcNameCliente =@ClienteDato.name
    $lcRucCliente  =@ClienteDato.ruc

    @customerpayment_rpt = @company.get_customer_payments_cliente(@fecha1,@fecha2,@cliente)  
      
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
    
    if @tipomoneda == "1"
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

      CustomerPayment::TABLE_HEADERS9.each do |header|
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
          
          if customerpayment_rpt.year_month.to_f >= 201701 and customerpayment_rpt.year_month.to_f <= 201707
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance.round(2)        
          end   

          if customerpayment_rpt.year_month == '201708' 
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance.round(2)        
          end 
            
          if customerpayment_rpt.year_month == '201709'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201710'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201711'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201712'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201801' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201802'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201803'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201804'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201805'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201806'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance.round(2)        
          end   
          
          
        else
          
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

          if customerpayment_rpt.year_month.to_f <= 201612
            @total_anterior = @total_anterior + customerpayment_rpt.balance.round(2)          
          end             
          
          if customerpayment_rpt.year_month.to_f >= 201701 and customerpayment_rpt.year_month.to_f <= 201707
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance.round(2)        
          end   

          if customerpayment_rpt.year_month == '201708' 
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance.round(2)        
          end 
            
          if customerpayment_rpt.year_month == '201709'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201710'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201711'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201712'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201801' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201802'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201803'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201804'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201805'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance.round(2)        
          end 
          if customerpayment_rpt.year_month == '201806'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance.round(2)        
          end   
         
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
    @customerpayment_rpt = @company.get_customer_payments2(@tipomoneda,@fecha1,@fecha2)
  
    if @customerpayment_rpt != nil 
      
    Prawn::Document.generate "app/pdf_output/rpt_customerpayment2.pdf" , :page_layout => :landscape do |pdf|        
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment2.pdf"      
        
    end     
  
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  end 
  
  end

##-------------------------------------------------------------------------------------##
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
      total_general_soles = 0
      total_general_dolar = 0
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

        @totalgeneral_soles = 0
        @totalgeneral_dolar = 0

        for banco in @banks

        total1 = @company.get_customer_payments_value(@fecha1,@fecha2,banco.id)  

        if total1>0
              row = []                  
              row << nroitem.to_s
              row << banco.number 

              a = BankAcount.find(banco.id)
              

              if a.moneda_id == 1
                row << " "
                row << sprintf("%.2f",total1.to_s)
                @totalgeneral_dolar = @totalgeneral_dolar + total1 
              else
                row << sprintf("%.2f",total1.to_s)
                row << " "

                @totalgeneral_soles = @totalgeneral_soles + total1 
              end
              table_content2 << row
        end   

        end

        @total_factory = @company.get_customer_payments_value_otros(@fecha1,@fecha2,"factory") 
        @total_ajuste  = @company.get_customer_payments_value_otros(@fecha1,@fecha2,"ajuste") 
        @total_compen  = @company.get_customer_payments_value_otros(@fecha1,@fecha2,"compen") 
        @total_compen = @total_compen *-1 
        row = []
        row << nroitem.to_s
        row << "FACTORY :"
        row << sprintf("%.2f",@total_factory.to_s)
        row << " "

        table_content2 << row
        row = []
        row << nroitem.to_s
        row << "AJUSTE  :"
        row << sprintf("%.2f",@total_ajuste.to_s)
        row << " "

        table_content2 << row

        row = []
        row << nroitem.to_s
        row << "COMPENSACION :"
        
        row << sprintf("%.2f",@total_compen.to_s)
        
        row << " "
        table_content2 << row


        @totalgeneral_soles = @totalgeneral_soles  + @total_ajuste + @total_factory + @total_compen

        
          row = []
          row << nroitem.to_s
          row << "TOTAL => "
          row << sprintf("%.2f",@totalgeneral_soles.to_s)
          row << sprintf("%.2f",@totalgeneral_dolar.to_s)


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

#**

##-------------------------------------------------------------------------------------##
## RESUMEN DE INGRESO A BANCOS DETALLADO POR CLIENTE 
##-------------------------------------------------------------------------------------##
  
  def build_pdf_header_rpt8(pdf)
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

  def build_pdf_body_rpt8(pdf)
    
    pdf.text "COBRANZAS POR BANCO : Desde "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 11 ,:align => :left 
        
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general_soles = 0
      total_general_dolar = 0
      total_factory = 0
        headers2 = []
        table_content2 = []

        CustomerPayment::TABLE_HEADERS7.each do |header|
          cell = pdf.make_cell(:content => header)
          cell.background_color = "FFFFCC"
          headers2 << cell
        end
        table_content2 << headers2
        nroitem = 1
                
        @totalgeneral_soles = 0
        @totalgeneral_dolar = 0
        @detalle_bancos = @company.get_customer_payments_value_customer2(@fecha1,@fecha2,@bank_id)  
        row  = []
        
        
        if @detalle_bancos
                
        for d in @detalle_bancos
        
          
              row = []                  
              row << nroitem.to_s              
              row << d.bank_acount.number
              row << d.get_banco(d.bank_acount.bank_id)  
              row << d.fecha.strftime("%d/%m/%Y") 
              row << d.code
              row << d.customer.name 
              row << sprintf("%.2f",d.total.to_s)
              
              table_content2 << row

              @totalgeneral_soles = @totalgeneral_soles + d.total          

              nroitem = nroitem + 1      
        end   
    end 
          nroitem = nroitem + 1      

          row = []
          row << nroitem.to_s          
          row << " "        
          row << " "
          row << " "        
          row << " "          
          row << "TOTAL => "
          row << sprintf("%.2f",@totalgeneral_soles.to_s)
          

          table_content2 << row

          result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:right
                                          columns([4]).align=:right
                                          columns([5]).align=:left                                           
                                          columns([6]).align=:right                                          
                                        end
          pdf.text "" 
          pdf 


      
    end


    def build_pdf_footer_rpt8(pdf)
      
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end
  

  # Export cobrar  to PDF
  def rpt_ccobrar8_pdf

    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @bank_id = params[:bank_id]

    @customerpayment_rpt = @company.get_customer_payments(@fecha1,@fecha2)  
    
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment1.pdf") do |pdf|
        pdf.font "Helvetica"        
        pdf = build_pdf_header_rpt8(pdf)
        pdf = build_pdf_body_rpt8(pdf)
        build_pdf_footer_rpt8(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end


##
##FIN RESUMEN INGRESO A BANCOS 
##

##-------------------------------------------------------------------------------------##
## RESUMEN DE INGRESO A BANCOS DETALLADO POR FACTURA 
##-------------------------------------------------------------------------------------##
  
  def build_pdf_header_rpt9(pdf)
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

  def build_pdf_body_rpt9(pdf)
    
    pdf.text "Detalle por factura : " , :size => 11 ,:align => :left 
        
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general_soles = 0
      total_general_dolar = 0
      total_factory = 0
        headers2 = []
        table_content2 = []

        CustomerPayment::TABLE_HEADERS7.each do |header|
          cell = pdf.make_cell(:content => header)
          cell.background_color = "FFFFCC"
          headers2 << cell
        end
        table_content2 << headers2
        nroitem = 1
                
        @totalgeneral_soles = 0
        @totalgeneral_dolar = 0



        row  = []

        for d in @detalle_bancos 
        

              row = []                  

              row << nroitem.to_s              
              row << d.code 
              row << d.bank_acount.number
              row << d.get_banco(d.bank_acount.bank_id)  
              row << d.fecha.strftime("%d/%m/%Y") 
              row << d.nrofactura 
              row << d.customer.name 
              
              row << sprintf("%.2f",d.total.to_s)
              
            
              table_content2 << row

              @totalgeneral_soles = @totalgeneral_soles + d.total          

              nroitem = nroitem + 1      
        end   

          nroitem = nroitem + 1      

          row = []
          row << nroitem.to_s          
          row << " "        
          row << " "        
          row << " "
          row << " "        
          row << " "          
          row << "TOTAL => "
          row << sprintf("%.2f",@totalgeneral_soles.to_s)
          

          table_content2 << row

          result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:left                                           
                                          columns([7]).align=:right                                          
                                        end
          pdf.text "" 
          pdf 


      
    end


    def build_pdf_footer_rpt9(pdf)
      
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end


      pdf
      
  end


  # Export cobrar  to PDF
  def rpt_ccobrar9_pdf

    @company =Company.find(params[:id])
    @fecha1  = params[:fecha1]
    @fecha2  = params[:fecha2]
    @factura_id = params[:ac_item]

    @guias = Factura.find_by(["company_id = ? AND (code LIKE ?)", @company.id, "%"+ @factura_id + "%"])

    if @guias != nil 

    @detalle_bancos = @company.get_customer_payments_value_customer3(@factura_id)
    
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment1.pdf") do |pdf|
        pdf.font "Helvetica"        
        pdf = build_pdf_header_rpt9(pdf)
        pdf = build_pdf_body_rpt9(pdf)
        build_pdf_footer_rpt9(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment1.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    else 


    end 
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



  def export1 

    fecha1 =params[:fecha1]
    fecha2 =params[:fecha2]
    
    @company = Company.find(params[:company_id])
     Csubdiario.delete_all

     @customerpayments = @company.get_customer_payments(fecha1,fecha2)

      $lcSubdiario='21'

      subdiario = Numera.find_by(:subdiario=>'12')

      lastcompro = subdiario.compro.to_i + 1
      $lastcompro1 = lastcompro.to_s.rjust(6, '0')
  
      if subdiario
          nrocompro =  $lastcompro1
      end

     for c in @customerpayments 
        
        $lcFecha =c.fecha1.strftime("%Y-%m-%d")           
        $lcTotal =c.total
        lcId = c.id 
        $lcCuenta = c.BankAcount.cuenta 

        newsubdia =Csubdiario.new(:csubdia=>$lcSubdiario,:ccompro=>$lastcompro1,:cfeccom=>$lcFecha,
        :ccodmon=>"MN",:csitua=>"F",:ctipcam=>"0.00",:cglosa=>"COBRANZA ",:total1=> $lcTotal,:csubtotal=>0,
        :ctax=> 0 ,:factory=> 0,:ajuste=>0,:compen => 0,  :ctotal=>0,
        :ctipo=>"V",:cflag=>"N",:cdate=>$lcFecha,
        :chora=>"",  :cfeccam=>"",:cuser=>"SIST",
        :corig=>"",:cform=>"M",:cextor=>"",:ccodane=>"" ) 

        newsubdia.save

        @customerdetails =  c.get_payment_dato(lcId)

        if @customerdetails

           for  f in  @customerdetails

            if f.tipo == "1"

                parts = f.code.split("-")        
                serie = parts[0]
                numero   = parts[1]        
                serie='FF01-'

                f.code = serie << numero
                
            end 
                              
            newsubdia =Csubdiario.new(:csubdia=>$lcSubdiario,:ccompro=>$lastcompro1,:cfeccom=>$lcFecha,
            :ccodmon=>"MN",:csitua=>"F",:ctipcam=>"0.00",:cglosa=>f.code ,:total1=> 0,:csubtotal=>0,
            :ctax=> 0 ,:factory=>f.factory,:ajuste=>f.ajuste,:compen => f.compen,  :ctotal=>f.total,
            :ctipo=>"V",:cflag=>"N",:cdate=>f.fecha.strftime("%Y-%m-%d") ,
            :chora=>"",  :cfeccam=>"",:cuser=>"SIST",
            :corig=>"",:cform=>"M",:cextor=>"",:ccodane=>f.customer.ruc) 

            newsubdia.save
            
            end

            lastcompro = lastcompro + 1

            $lastcompro1 = lastcompro.to_s.rjust(4, '0')      
            subdiario.compro = $lastcompro1
            subdiario.save

        end 

       end  
      
      @invoice = Csubdiario.all
      send_data @invoice.to_csv  , :filename => 'CB0217.csv'
    
  end
  def generar1
    @company = Company.find(params[:company_id])
    
  end

##-------------------------------------------------------------------------------------
## reporte completo de cobranza 
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt10(pdf)
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


  def build_pdf_body_rpt10(pdf)
    
    pdf.text "Listado de Cobranza Emitidas : Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general_soles = 0
      total_general_dolar = 0
      total_factory = 0

      CustomerPayment::TABLE_HEADERS8.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

       for  detalle in @customerpayment_rpt
       puts detalle.total 
               $lcFecha1 = detalle.fecha1.strftime("%d/%m/%Y")                  
                row = []
                row << nroitem.to_s
                row << detalle.code 
                row << detalle.get_banco(detalle.bank_acount.bank_id) 
                row << detalle.get_moneda(detalle.bank_acount.moneda_id)
                
                row << $lcFecha1 
               
                if detalle.document 
                row << detalle.document.description     
                else
                row << ".."
                end 
                row << detalle.documento   
                row << detalle.nrooperacion
                row << ""
                row << detalle.total 
                row << ""
                table_content << row  
                
                tfactory = 0
                tcompen  = 0
                tajuste  = 0
                ttotal = 0
                diferencia = 0
                for productItem in detalle.get_payments()
                  row = []
                  row << ""
                  row << ""
                  row << ""
                  row << ""
                  
                  row << productItem.code  
                  
                  
                  row << productItem.get_customer(productItem.customer_id)
                  row << sprintf("%.2f",productItem.factory.to_s)
                  row << sprintf("%.2f",productItem.compen.to_s)
                  row << sprintf("%.2f",productItem.ajuste.to_s)  
                  row << sprintf("%.2f",productItem.total.to_s)
                  row << 0
                  table_content << row
                  
                  tfactory+= productItem.factory 
                  tcompen += productItem.compen 
                  tajuste += productItem.ajuste 
                  ttotal +=  productItem.total
               end
                
                   row = []
                  row << ""
                  row << ""
                  row << ""
                  row << ""
                  row << ""
                  diferencia = detalle.total -  ttotal + tfactory -tcompen+tajuste 
                  
                  row << "TOTALES=>"
                  row << sprintf("%.2f",tfactory.to_s)
                  row << sprintf("%.2f",tcompen.to_s)
                  row << sprintf("%.2f",tajuste.to_s)
                  row << sprintf("%.2f",ttotal.to_s)
                  row << sprintf("%.2f",diferencia.to_s )
                  
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
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                          columns([11]).align=:right
                                          columns([12]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

  

  
  end

  def build_pdf_footer_rpt10(pdf)
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
      end
      pdf
    
  end 
  # Export cobrar  to PDF

  def rpt_ccobrar10_pdf
    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    
    @customerpayment_rpt = @company.get_customer_payments_cabecera(@fecha1,@fecha2)  
      
    Prawn::Document.generate("app/pdf_output/rpt_customerpayment.pdf") do |pdf|
        pdf.font "Helvetica"        
        pdf = build_pdf_header_rpt10(pdf)
        pdf = build_pdf_body_rpt10(pdf)
        build_pdf_footer_rpt10(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end



  #####
  
  
##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt11(pdf)
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

  def build_pdf_body_rpt11(pdf)
    
    if @tipomoneda == "1"
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
      
      if @customerpayment_rpt.first 
      lcCli = @customerpayment_rpt.first.customer_id
      else
        lcCli = ""
      end 
      $lcCliName = ""
    
     for  customerpayment_rpt in @customerpayment_rpt

        if lcCli == customerpayment_rpt.customer_id 

          $lcCliName = customerpayment_rpt.customer.name  
      
          if customerpayment_rpt.year_month.to_f <= 201612
            @total_anterior = @total_anterior + customerpayment_rpt.balance.round(2)          
          end             
          
          if customerpayment_rpt.year_month.to_f == '201701' 
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

          if customerpayment_rpt.year_month.to_f <= 201612
            @total_anterior = @total_anterior + customerpayment_rpt.balance.round(2)          
          end             
          
          if customerpayment_rpt.year_month.to_f == '201701'
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
            if customerpayment_rpt != nil  
            row << customerpayment_rpt.customer.name  
            else
            row << " "
            end 
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


    def build_pdf_footer_rpt11(pdf)

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


  def rpt_ccobrar11_pdf
    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @tipomoneda = params[:moneda_id]

    @company.actualizar_fecha20(@fecha1,@fecha2)
    
    @customerpayment_rpt = @company.get_customer_payments20(@tipomoneda,@fecha1,@fecha2)
    if @customerpayment_rpt  
    Prawn::Document.generate "app/pdf_output/rpt_customerpayment2.pdf" , :page_layout => :landscape do |pdf|        
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt11(pdf)
        pdf = build_pdf_body_rpt11(pdf)
        build_pdf_footer_rpt11(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment2.pdf"      
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    end 
  end

  

  #####
  private
  
  def customerpayment_params
    params.require(:customer_payment).permit(:company_id,:location_id,:division_id,:bank_acount_id,
      :document_id,:documento,:customer_id,:tm,:total,:fecha1,:fecha2,:nrooperacion,:operacion,
      :descrip,:comments,:user_id,:processed,:code,:concept_id)

  end

end 
