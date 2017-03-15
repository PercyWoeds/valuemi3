
include UsersHelper
include CustomersHelper
include ServicesHelper

class DeliveriesController < ApplicationController
  before_filter :authenticate_user!, :checkServices

def import
      Delivery.import(params[:file])
       redirect_to root_url, notice: "Clientes importadas."
  end 

def unir
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @pagetitle = "Agrega guia de remision "
    @mines =  Delivery.where([" code like ?", "%" + params[:ac_gt] + "%"]).first 
    $minesid= @mines.id
    @guias =  @mines.get_guiaremision    
    
end
      
def search
  if params[:search].blank?
  
  else
      @Customer = Delivery.search(params[:search_param])  
      if @deliveries
        return @deliveries

      else
          flash[:notice] = "Cliente no encontrado"
      end
  end

    render :layout => false
end


def add_friend

  @friend = Delivery.find(params[:delivery])

  Delivery.declaration_deliveries.build(delivery_id: @friend.id)

  if DeclarationDelivery.save
    redirect_to my_friends_path, notice: "Guia was successfully added."
  else
    

    redirect_to my_friends_path, flash[:error] = "There was an error with adding user as guia."
  end

end

 
  def add_guias(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        begin
          guia = Delivery.find(id.to_i)
          
          new_invoice_guia = Deliveryship.new(:factura_id => self.id, :delivery_id => guia.id)          
          new_invoice_guia.save
           
        rescue
          
        end
      end
    end
  end
  

  
  # Export delivery to PDF
  def pdf
    @delivery = Delivery.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/deliveries/pdf/#{@delivery.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end

  def do_unir
    @company = Company.find(params[:company_id])

    @deliverymines =Deliverymine.all 
  
  end 
  

  # Process an delivery
  def do_process
    @delivery = Delivery.find(params[:id])
    @delivery[:processed] = '1'
    
    @delivery.process
    
    flash[:notice] = "The delivery order has been processed."
    redirect_to @delivery
  end


# Anular an delivery
  def do_anular
    @delivery = Delivery.find(params[:id])
    @delivery[:processed] = '2'
    
    @delivery.anular 
    
    flash[:notice] = "The delivery order has been processed."
    redirect_to @delivery
  end
 
  # Do send delivery via email
  def do_email
    @delivery = Delivery.find(params[:id])
    @email = params[:email]
    
    Notifier.delivery(@email, @delivery).deliver
    
    flash[:notice] = "The delivery has been sent successfully."
    redirect_to "/deliveries/#{@delivery.id}"
  end
  
  # Send delivery via email
  def email
    @delivery = Delivery.find(params[:id])
    @company = @delivery.company
  
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0
    puts items 

    for item in items
      if item != "" 
        parts = item.split("|BRK|")
        

        id = parts[0]
        quantity = parts[1]
        unidad_id = parts[2]
        peso     = parts[3]
        price    = parts[4]
        discount = parts[5]

        
        product = Service.find(id.to_i)
        product[:i] = i
        product[:unidad_id] = unidad_id.to_i
        product[:peso] = peso.to_i 
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
          product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
    
  
  
  # Autocomplete for products
  def ac_services
    @products = Service.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
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
  # Autocomplete for customers
  def ac_unidads
    @unidads = Unidad.where(["company_id = ? AND descrip LIKE ?", params[:company_id], "%" + params[:q] + "%"])

    render :layout => false
  end
  # Autocomplete for guias
  def ac_guias
    @guias = Delivery.where(["company_id = ? AND (code  LIKE ?)", params[:company_id], "%" + params[:q] + "%"])
  
    render :layout => false
  end
  
  # Show deliverys for a company
  def list_deliveries

    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - guias"
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
        if(params[:search] and params[:search] != "")
          @deliveries = Delivery.where(["company_id = ? AND code like ? ", @company.id, "%" + params[:search] + "%"]).paginate(:page => params[:page])

        else
          @deliveries = Delivery.where(company_id:  @company.id).order("code desc ").paginate(:page => params[:page])
          @filters_display = "none"
        end
    else
      errPerms()
    end
  end
  
  # GET /deliverys
  # GET /deliverys.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path ="guia"
    @pagetitle = "deliverys"
  end

  # GET /deliverys/1
  # GET /deliverys/1.xml
  def show
    @delivery  = Delivery.find(params[:id])
    @customer = @delivery.customer    
    @remite  =  Customer.find(@delivery.remite_id)
    @addresses  = Address.find(@delivery.address_id)
    @addresses2 = Address.find(@delivery.address2_id)

  end

  # GET /deliverys/new
  # GET /deliverys/new.xml
  
  def new
    @pagetitle = "Nueva Guia"
    @action_txt = "Create"
    
    @delivery = Delivery.new
    @delivery[:code] = "#{generate_guid2()}"
    @delivery[:processed] = false
    
    @company = Company.find(params[:company_id])
    @delivery.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @customers = @company.get_customers()
    @remites = @company.get_customers()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    @addresses2  = @company.get_addresses()

    @services  = @company.get_services()
    @servicebuys  = @company.get_servicebuys()

    @transports = @company.get_transports()

    @ac_user = getUsername()
    @delivery[:user_id] = getUserId()
  end

  # GET /deliverys/1/edit
  def edit
    @pagetitle = "Edit delivery"
    @action_txt = "Update"
    
    @delivery = Delivery.find(params[:id])
    @company = @delivery.company

    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @customers = @company.get_customers()
    @remites   = @company.get_customers()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    @addresses2  = @company.get_addresses()

    @services  = @company.get_services()
    @servicebuys  = @company.get_servicebuys()

    @ac_customer = @delivery.customer.name
    @ac_user = @delivery.user.username
    @payments = @company.get_payments()    
    
    @services  = @company.get_services()
    @servicebuys  = @company.get_servicebuys()

    @products_lines = @delivery.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @transports = @company.get_transports()
  end

  # POST /deliverys
  # POST /deliverys.xml
  def create
    @pagetitle = "Nueva guia"
    @action_txt = "Create"
      
    items = params[:items].split(",")
    
    @delivery = Delivery.new(delivery_params)
    
    @company = Company.find(params[:delivery][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    @addresses2  = @company.get_addresses()
    @services  = @company.get_services()      
    @servicebuys  = @company.get_servicebuys()
    @customers = @company.get_customers()
    @remites = @company.get_customers()
    @transports = @company.get_transports()

    @delivery[:subtotal] = @delivery.get_subtotal(items)
        
    begin
      @delivery[:tax] = @delivery.get_tax(items, @delivery[:customer_id])
    rescue
      @delivery[:tax] = 0
    end
    
    @delivery[:total] = @delivery[:subtotal] + @delivery[:tax]
    
    if(params[:delivery][:user_id] and params[:delivery][:user_id] != "")
      curr_seller = User.find(params[:delivery][:user_id])
        @ac_user = curr_seller.username
    end        
        
    respond_to do |format|
      if @delivery.save 
        # Create products for kit
        @delivery.add_services(items)
        # Check if we gotta process the delivery
        @delivery.process()
        @delivery.correlativo()              
        format.html { redirect_to(@delivery, :notice => 'delivery was successfully created.') }
        format.xml  { render :xml => @delivery, :status => :created, :location => @delivery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    
    end

  end
  

  # PUT /deliverys/1
  # PUT /deliverys/1.xml
  def update
    @pagetitle = "Edit delivery"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @delivery = Delivery.find(params[:id])
    @company = @delivery.company
    @payments = @company.get_payments()    
    @transports = @company.get_transports()

    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @delivery.customer.name
    end
    
    @products_lines = @delivery.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    @addresses2  = @company.get_addresses()
    @services  = @company.get_services()      
    @servicebuys  = @company.get_servicebuys()
    @customers = @company.get_customers()
    @remites = @company.get_customers()

    @delivery[:subtotal] = @delivery.get_subtotal(items)
    @delivery[:tax] = @delivery.get_tax(items, @delivery[:customer_id])
    @delivery[:total] = @delivery[:subtotal] + @delivery[:tax]


    remision =@delivery[:remision]
    code = @delivery[:code]
    fecha1 =@delivery[:fecha1]
    fecha2 =@delivery[:fecha2]
    remite_id =@delivery[:remite_id]
    address_id = @delivery[:address_id]
    location_id =@delivery[:location_id]
    division_id = @delivery[:division_id]
    customer_id = @delivery[:customer_id]
    address2_id = @delivery[:address2_id]
    description =@delivery[:description]
     processed = @delivery[:processed]
     truck_id =@delivery[:truck_id]
     truck2_id = @delivery[:truck2_id]
     employee_id = @delivery[:employee_id]
     subcontrat_id = @delivery[:subcontrat_id]
     user_id =@delivery[:user_id]
     company_id = @delivery[:company_id]
     return1=""
     date_processed = Date.today 
     tranportorder_id = @delivery[:tranportorder_id]
     comments=""
     subtotal = 0
     tax = 0
     total = 0
     empsub_id =@delivery[:empsub_id]


    respond_to do |format|
      if @delivery.update(delivery_params)
      
        # Create products for kit
        #@delivery.delete_services()
        #@delivery.add_services(items)
        
        # Check if we gotta process the delivery
        @delivery.process()
        
        format.html { redirect_to(@delivery, :notice => 'delivery was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverys/1,a
  # DELETE /deliverys/1.xml
  def destroy
    @delivery = Delivery.find(params[:id])
    company_id = @delivery[:company_id]

    
      @delivery.destroy    
      respond_to do |format|
        format.html { redirect_to("/companies/deliveries/" + company_id.to_s) }
      end
    

  end
##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS EMITIDAS
##-----------------------------------------------------------------------------------
  def build_pdf_header(pdf)
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


      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "Guias EMITIDAS  : Desde "+@fecha1.to_s  + "Hasta : "+ @fecha2.to_s, :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @delivery

            lcOrigen = product.get_origen(product.remite_id)
            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.created_at.strftime("%d/%m/%Y")
            if product.fecha3 == nil
              row << "-"
            else 
              row << product.fecha3.strftime("%d/%m/%Y")
            end
            if product.fecha4 == nil
              row << "-"
            else
              row << product.fecha4.strftime("%d/%m/%Y")
            end 
            row << product.get_remision
            row << product.code
            row << lcOrigen
            row << product.customer.name      

            row << product.description
            
            if    product.tranportorder_id != nil 
              row << product.tranportorder.code
              @ost= product.get_ost(product.tranportorder.id)

              row << product.get_punto(@ost.ubication_id)
              row << product.get_punto(@ost.ubication2_id)

            else
              row << "No asignado" 
              row << " "
              row << " "
            end 
            row << product.get_processed
            table_content << row

            nroitem=nroitem + 1
             
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([1]).width= 40    
                                          columns([2]).align=:left
                                          columns([2]).width= 40    
                                          columns([3]).align=:left
                                          columns([3]).width= 40    
                                          columns([4]).align=:left  
                                          columns([5]).align=:right
                                          columns([6]).align=:left 
                                          columns([7]).align=:left
                                          columns([8]).align=:left
                                          columns([9]).align=:left 
                                          columns([9]).width= 100 
                                          columns([10]).align=:left
                                          columns([10]).width= 80
                                          columns([11]).align=:left
                                          columns([12]).align=:left
                                          columns([13]).align=:left
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
  def guias1
    @company=Company.find(params[:company_id])      
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
      
    @delivery = @company.get_guias_day(@fecha1,@fecha2)  

      
    Prawn::Document.generate("app/pdf_output/guias1.pdf") do |pdf|      

        pdf.start_new_page(:size => "A4", :layout => :landscape)
        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/guias1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/guias1.pdf", :type => 'application/pdf', :disposition => 'inline')

  end

##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS EMITIDAS 2
##-----------------------------------------------------------------------------------
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


      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body2(pdf)
    
    pdf.text "Guias por facturar  : Desde "+@fecha1.to_s  + "Hasta : "+ @fecha2.to_s, :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS1.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @delivery

            lcOrigen = product.get_origen(product.remite_id)

            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.created_at.strftime("%d/%m/%Y")
            row << product.get_remision
            row << product.code
            row << lcOrigen
            row << product.customer.name              
            row << product.get_processed
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
                                          columns([5]).align=:left 
                                          columns([6]).align=:left
                                          
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



  def guias2
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    

    @delivery = @company.get_guias_2(@fecha1,@fecha2)  
      
    Prawn::Document.generate("app/pdf_output/guias2.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/guias2.pdf"            
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName

    send_file("app/pdf_output/guias2.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS PENDIENTES CORRELATIVO 2
##-----------------------------------------------------------------------------------
  def build_pdf_header3(pdf)
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


      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body3(pdf)
    
    pdf.text "Guias NO REGISTRADAS : Desde "+@fecha1.to_s  + "Hasta : "+ @fecha2.to_s, :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem = 1

      min_code = min_code


     while(min_code <= max_code)

      if(i < 10)
        i_s = "0#{i}"
      else
        i_s = i.to_s
      end
      
      @dates.push("#{@year}-#{month_s}-#{i_s}")
      @date_cats.push("'" + doDate(Time.parse("#{@year}-#{@month}-#{i_s}"), 5) + "'")
      
      i += 1
    end

       for  product in @delivery

            lcOrigen = product.get_origen(product.remite_id)

            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.created_at.strftime("%d/%m/%Y")
            row << product.get_remision
            row << product.code
            row << lcOrigen
            row << product.customer.name              
            row << product.description 
            row << product.get_processed
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
                                          columns([5]).align=:left 
                                          columns([6]).align=:left
                                          columns([7]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer3(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  def guias3
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   
    
    @delivery = @company.get_guias_3(@fecha1,@fecha2)  

    @delivery_max_min =  Delivery.select("MAX(code) max_code,MIN(code) mix_code").first.attributes

    maximo = @delivery_max_min.max_code
    minimo = @delivery_max_min.min_code


    Prawn::Document.generate("app/pdf_output/guias3.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header3(pdf)
        pdf = build_pdf_body3(pdf)
        build_pdf_footer3(pdf)
        $lcFileName =  "app/pdf_output/guias3.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("app/pdf_output/guias3.pdf", :type => 'application/pdf', :disposition => 'inline')
  end
##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS INGRESADAS X FECHA INGRESO 
##-----------------------------------------------------------------------------------
  def build_pdf_header4(pdf)
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


      pdf.move_down 25
      pdf 
  end   
  

  def build_pdf_body4(pdf)
    
    pdf.text "Guias por fecha ingreso  : Desde "+@fecha1.to_s  + "Hasta : "+ @fecha2.to_s, :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1
     
       for  product in @delivery
            lcOrigen = product.get_origen(product.remite_id)
            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")            
            row << product.created_at.strftime("%d/%m/%Y")
            row << product.fecha3.strftime("%d/%m/%Y")
            row << product.fecha4.strftime("%d/%m/%Y")
            row << product.get_remision
            row << product.code
            row << lcOrigen
            row << product.customer.name                          
            row << product.get_processed
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
                                          columns([5]).align=:left                                         
                                          columns([6]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer4(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


  def guias4
    @company=Company.find(params[:company_id])      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   
    @delivery = @company.get_guias_4(@fecha1,@fecha2)  

    Prawn::Document.generate("app/pdf_output/guias4.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header4(pdf)
        pdf = build_pdf_body4(pdf)
        build_pdf_footer4(pdf)
        $lcFileName =  "app/pdf_output/guias4.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("app/pdf_output/guias4.pdf", :type => 'application/pdf', :disposition => 'inline')
  end


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




  def discontinue

    @guiasselect = Delivery.find(params[:products_ids])

    for item in @guiasselect
        begin
          a = item.id
          b = item.remite_id               

          new_invoice_guia = Deliverymine.new(:mine_id =>$minesid, :delivery_id =>item.id)          
          new_invoice_guia.save
           
        
         end              
    end
    
    redirect_to deliveries_url 

  end 

  
  def editmultiple

    if params[:products_ids] != nil 

        @guiasselect = Delivery.find(params[:products_ids])      
    end     
  end

  def updatemultiple
 
       Delivery.where(id: params[:products_ids]).update_all(params[:delivery])
        
      flash[:notice] = "Guias modificadas"
      redirect_to  "/companies/deliveries/1" 
      
  end

  private
  def delivery_params
    params.require(:delivery).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:fecha1,:fecha2,:employee_id,:empsub_id,:subcontrat_id,:truck_id,:truck2_id,:address_id,:remision,:remite_id,:address2_id,:tranportorder_id,:fecha3,:fecha4)
  end

end




