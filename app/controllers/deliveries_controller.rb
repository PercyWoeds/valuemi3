
include UsersHelper
include CustomersHelper
include ServicesHelper

class DeliveriesController < ApplicationController
  before_filter :authenticate_user!, :checkServices
    
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
  
  # Export delivery to PDF
  def pdf
    @delivery = Delivery.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/deliveries/pdf/#{@delivery.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an delivery
  def do_process
    @delivery = Delivery.find(params[:id])
    @delivery[:processed] = true
    
    @delivery.process
    
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
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    @services  = @company.get_services()

    @ac_user = getUsername()
    @delivery[:user_id] = getUserId()
  end

  # GET /deliverys/1/edit
  def edit
    @pagetitle = "Edit delivery"
    @action_txt = "Update"
    
    @delivery = Delivery.find(params[:id])
    @company = @delivery.company

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    @customers = @company.get_customers()

    @ac_customer = @delivery.customer.name
    @ac_user = @delivery.user.username
    @payments = @company.get_payments()    
    @addresses  = @company.get_addresses()
    @services  = @company.get_services()


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
    @services  = @company.get_services()      
    @customers = @company.get_customers()

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

  private
  def delivery_params
    params.require(:delivery).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:fecha1,:fecha2,:employee_id,:empsub_id,:subcontrat_id,:truck_id,:truck2_id,:address_id,:remision)
  end

end



