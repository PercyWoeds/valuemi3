
include UsersHelper
include CustomersHelper
include ServicesHelper

class DeliveriesController < ApplicationController
  before_filter :authenticate_user!, :checkServices


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
      if(params[:ac_customer] and params[:ac_customer] != "")
        @customer = Customer.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_customer].strip})
        
        if @customer
          @deliveries = Delivery.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any deliverys for that customer."
          redirect_to "/companies/deliveries/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @deliveries = Delivery.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any deliverys for that customer."
          redirect_to "/companies/deliveries/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @deliveries = Delivery.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @deliveries = Delivery.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @deliveries = Delivery.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @deliveries = Delivery.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @deliveries = Delivery.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
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
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @delivery.customer.name
    end
    
    @products_lines = @delivery.products_lines
    
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

    respond_to do |format|
      if @delivery.update_attribute(delivery_params)
        # Create products for kit
        @delivery.delete_services()
        @delivery.add_services(items)
        
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
    
    pdf.text "Guias Emitidas : Año "+@year.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 8



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

            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.get_remision
            row << product.code
            row << product.customer.name  
            row << product.subtotal.to_s
            row << product.tax.to_s
            row << product.total.to_s
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
  def guias1
    @company=Company.find(params[:company_id])      
    
    
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
    
    @delivery = @company.get_guias_year_month(@year,@month)  
      
    Prawn::Document.generate("app/pdf_output/guias1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/guias1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

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

  private
  def delivery_params
    params.require(:delivery).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:fecha1,:fecha2,:employee_id,:empsub_id,:subcontrat_id,:truck_id,:truck2_id,:address_id,:remision,:remite_id,:address2_id)
  end

end




