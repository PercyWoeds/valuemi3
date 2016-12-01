
include UsersHelper
include CustomersHelper
include ServicesHelper

class GuiasController < ApplicationController

  before_filter :authenticate_user!, :checkServices
  
  # Export guia to PDF
  def pdf
    @guia = Guia.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/guias/pdf/#{@guia.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an guia
  def do_process
    @guia = Guia.find(params[:id])
    @guia[:processed] = true
    
    @guia.process
    
    flash[:notice] = "The guia order has been processed."
    redirect_to @guia
  end
  
  # Do send guia via email
  def do_email
    @guia = Guia.find(params[:id])
    @email = params[:email]
    
    Notifier.guia(@email, @guia).deliver
    
    flash[:notice] = "The guia has been sent successfully."
    redirect_to "/guias/#{@guia.id}"
  end
  
  # Send guia via email
  def email
    @guia = Guia.find(params[:id])
    @company = @guia.company
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
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        product = Service.find(id.to_i)
        product[:i] = i
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
  
  # Show guias for a company
  def list_guias
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
          @guias = Guia.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any guias for that customer."
          redirect_to "/companies/guias/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @guias = Guia.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any guias for that customer."
          redirect_to "/companies/guias/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @guias = Guia.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @guias = Guia.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @guias = Guia.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @guias = Guia.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @guias = Guia.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /guias
  # GET /guias.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'guia'
    @pagetitle = "guias"
  end

  # GET /guias/1
  # GET /guias/1.xml
  def show
    @guia = Guia.find(params[:id])
    @customer = @guia.customer
    
  end

  # GET /guias/new
  # GET /guias/new.xml
  
  def new
    @pagetitle = "Nueva guia"
    @action_txt = "Create"
    
    @guia = Guia.new
    @guia[:code] = "I_#{generate_guid()}"
    @guia[:processed] = false
    
    @company = Company.find(params[:company_id])
    @guia.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()

    @ac_user = getUsername()
    @guia[:user_id] = getUserId()
  end

  # GET /guias/1/edit
  def edit
    @pagetitle = "Edit guia"
    @action_txt = "Update"
    
    @guia = Guia.find(params[:id])
    @company = @guia.company
    @ac_customer = @guia.customer.name
    @ac_user = @guia.user.username
    @payments = @company.get_payments()    

    @products_lines = @guia.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /guias
  # POST /guias.xml
  def create
    @pagetitle = "Nueva guia "
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @guia = Guia.new(guia_params)
    
    @company = Company.find(params[:guia][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()    

    @guia[:subtotal] = @guia.get_subtotal(items)
    
    begin
      @guia[:tax] = @guia.get_tax(items, @guia[:customer_id])
    rescue
      @guia[:tax] = 0
    end
    
    @guia[:total] = @guia[:subtotal] + @guia[:tax]
    
    if(params[:guia][:user_id] and params[:guia][:user_id] != "")
      curr_seller = User.find(params[:guia][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @guia.save
        # Create products for kit
        @guia.add_products(items)
        
        # Check if we gotta process the guia
        @guia.process()
        
        format.html { redirect_to(@guia, :notice => 'guia was successfully created.') }
        format.xml  { render :xml => @guia, :status => :created, :location => @guia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @guia.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /guias/1
  # PUT /guias/1.xml
  def update
    @pagetitle = "Edit guia"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @guia = Guia.find(params[:id])
    @company = @guia.company
    @payments = @company.get_payments()    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @guia.customer.name
    end
    
    @products_lines = @guia.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @guia[:subtotal] = @guia.get_subtotal(items)
    @guia[:tax] = @guia.get_tax(items, @guia[:customer_id])
    @guia[:total] = @guia[:subtotal] + @guia[:tax]

    respond_to do |format|
      if @guia.update_attributes(guia_params)
        # Create products for kit
        @guia.delete_products()
        @guia.add_products(items)
        
        # Check if we gotta process the guia
        @guia.process()
        
        format.html { redirect_to(@guia, :notice => 'guia was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /guias/1
  # DELETE /guias/1.xml
  def destroy
    @guia = Guia.find(params[:id])
    company_id = @guia[:company_id]
    @guia.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/guias/" + company_id.to_s) }
    end
  end

  private
  def guia_params
    params.require(:guia).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:payment_id,:fecha,:fecha1,:fecha2)
  end

end



