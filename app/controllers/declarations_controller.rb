include UsersHelper
include CustomersHelper
include DeliveriesHelper

class DeclarationsController < ApplicationController
  before_filter :authenticate_user!, :checkDeliveries
    
  
  # Export declaration to PDF
  def pdf
    @declaration = Declaration.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/declarations/pdf/#{@declaration.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an declaration
  def do_process
    @declaration = Declaration.find(params[:id])
    @declaration[:processed] = true
    
    @declaration.process
    
    flash[:notice] = "The declaration order has been processed."
    redirect_to @declaration
  end
  
  # Do send declaration via email
  def do_email
    @declaration = Declaration.find(params[:id])
    @email = params[:email]
    
    Notifier.declaration(@email, @declaration).deliver
    
    flash[:notice] = "The declaration has been sent successfully."
    redirect_to "/declarations/#{@declaration.id}"
  end
  
  # Send declaration via email
  def email
    @declaration = Declaration.find(params[:id])
    @company = @declaration.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        puts parts

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
  
  # Show declarations for a company
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
          @deliveries = Declaration.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any declarations for that customer."
          redirect_to "/companies/declarations/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @deliveries = Declaration.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any declarations for that customer."
          redirect_to "/companies/declarations/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @deliveries = Declaration.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @deliveries = Declaration.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @deliveries = Declaration.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @deliveries = Declaration.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @deliveries = Declaration.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /declarations
  # GET /declarations.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path ="guia"
    @pagetitle = "declarations"
  end

  # GET /declarations/1
  # GET /declarations/1.xml
  def show
    @declaration  = Declaration.find(params[:id])
    @customer = @declaration.customer    
    
  end

  # GET /declarations/new
  # GET /declarations/new.xml
  
  def new
    @pagetitle = "Nueva Guia"
    @action_txt = "Create"
    
    @declaration = Declaration.new
    @declaration[:code] = "#{generate_guid3()}"
    @declaration[:processed] = false
    
    @company = Company.find(params[:company_id])
    @declaration.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
    
    @ac_user = getUsername()
    @declaration[:user_id] = getUserId()
  end

  # GET /declarations/1/edit
  def edit
    @pagetitle = "Edit declaration"
    @action_txt = "Update"
    
    @declaration = Declaration.find(params[:id])
    @company = @declaration.company

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    
    @ac_customer = @declaration.customer.name
    @ac_user = @declaration.user.username
    @payments = @company.get_payments()    
    @addresses  = @company.get_addresses()

    @products_lines = @declaration.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /declarations
  # POST /declarations.xml
  def create
    @pagetitle = "Nueva Manifiesto"
    @action_txt = "Create"
      
    items = params[:items].split(",")
    
    @declaration = Declaration.new(declaration_params)
    
    @company = Company.find(params[:declaration][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @trucks    = @company.get_trucks()
    @employees = @company.get_employees()
    @empsubs   = @company.get_empsubs()
    @unidads   = @company.get_unidads()
    @addresses  = @company.get_addresses()
      

    @declaration[:subtotal] = @declaration.get_subtotal(items)
    
    begin
      @declaration[:tax] = @declaration.get_tax(items, @declaration[:customer_id])
    rescue
      @declaration[:tax] = 0
    end
    
    @declaration[:total] = @declaration[:subtotal] + @declaration[:tax]
    
    if(params[:declaration][:user_id] and params[:declaration][:user_id] != "")
      curr_seller = User.find(params[:declaration][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @declaration.save
        # Create products for kit
        @declaration.add_services(items)
        
        # Check if we gotta process the declaration
        @declaration.process()

        @declaration.correlativo()
        
        format.html { redirect_to(@declaration, :notice => 'declaration was successfully created.') }
        format.xml  { render :xml => @declaration, :status => :created, :location => @declaration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @declaration.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /declarations/1
  # PUT /declarations/1.xml
  def update
    @pagetitle = "Edit declaration"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @declaration = Declaration.find(params[:id])
    @company = @declaration.company
    @payments = @company.get_payments()    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @declaration.customer.name
    end
    
    @products_lines = @declaration.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @declaration[:subtotal] = @declaration.get_subtotal(items)
    @declaration[:tax] = @declaration.get_tax(items, @declaration[:customer_id])
    @declaration[:total] = @declaration[:subtotal] + @declaration[:tax]

    respond_to do |format|
      if @declaration.update_attribute(declaration_params)
        # Create products for kit
        @declaration.delete_services()
        @declaration.add_services(items)
        
        # Check if we gotta process the declaration
        @declaration.process()
        
        format.html { redirect_to(@declaration, :notice => 'declaration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @declaration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /declarations/1,a
  # DELETE /declarations/1.xml
  def destroy
    @declaration = Declaration.find(params[:id])
    company_id = @declaration[:company_id]
    @declaration.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/declarations/" + company_id.to_s) }
    end
  end

  private
  def declaration_params
    params.require(:declaration).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:fecha1,:fecha2,:employee_id,:empsub_id,:subcontrat_id,:truck_id,:truck2_id,:address_id,:remision)
  end

end



