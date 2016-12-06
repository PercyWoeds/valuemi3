
include UsersHelper
include SuppliersHelper
include ServicebuysHelper

class ServiceordersController < ApplicationController

  before_filter :authenticate_user!, :checkServices
 
  
  # Export serviceorder to PDF
  def pdf
    @serviceorder = Serviceorder.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/serviceorders/pdf/#{@serviceorder.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an serviceorder
  def do_process
    @serviceorder = Serviceorder.find(params[:id])
    @serviceorder[:processed] = true
    
    @serviceorder.process
    
    flash[:notice] = "The serviceorder order has been processed."
    redirect_to @serviceorder
  end
  
  # Do send serviceorder via email
  def do_email
    @serviceorder = Serviceorder.find(params[:id])
    @email = params[:email]
    
    Notifier.serviceorder(@email, @serviceorder).deliver
    
    flash[:notice] = "The serviceorder has been sent successfully."
    redirect_to "/serviceorders/#{@serviceorder.id}"
  end
  
  # Send serviceorder via email
  def email
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
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
        
        product = Servicebuy.find(id.to_i)
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
  def ac_products
    @products = Product.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])   
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
  
  # Autocomplete for suppliers
  def ac_suppliers
    @suppliers = Supplier.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])

    render :layout => false
  end
  
  # Show serviceorders for a company
  def list_serviceorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - serviceorders"
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
      if(params[:ac_supplier] and params[:ac_supplier] != "")
        @supplier = supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = Supplier.find(params[:supplier])
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @serviceorders = Serviceorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @serviceorders = Serviceorder.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /serviceorders
  # GET /serviceorders.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'serviceorders'
    @pagetitle = "serviceorders"
  end

  # GET /serviceorders/1
  # GET /serviceorders/1.xml
  def show
    @serviceorder = Serviceorder.find(params[:id])
    @supplier = @serviceorder.supplier
  end

  # GET /serviceorders/new
  # GET /serviceorders/new.xml
  
  def new
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    @serviceorder = Serviceorder.new
    @serviceorder[:code] = "I_#{generate_guid()}"
    @serviceorder[:processed] = false
    
    @company = Company.find(params[:company_id])
    @serviceorder.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @servicebuys  = @company.get_servicebuys()
    
    @ac_user = getUsername()
    @serviceorder[:user_id] = getUserId()
  end

  # GET /serviceorders/1/edit
  def edit
    @pagetitle = "Edit serviceorder"
    @action_txt = "Update"
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    @ac_supplier = @serviceorder.supplier.name
    @ac_user = @serviceorder.user.username
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()

    
    @products_lines = @serviceorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /serviceorders
  # POST /serviceorders.xml
  def create
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.new(serviceorder_params)
    
    @company = Company.find(params[:serviceorder][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()

    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    
    begin
      @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    rescue
      @serviceorder[:tax] = 0
    end
    
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]
    
    if(params[:serviceorder][:user_id] and params[:serviceorder][:user_id] != "")
      curr_seller = User.find(params[:serviceorder][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @serviceorder.save
        # Create products for kit
        @serviceorder.add_services(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully created.') }
        format.xml  { render :xml => @serviceorder, :status => :created, :location => @serviceorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /serviceorders/1
  # PUT /serviceorders/1.xml
  def update
    @pagetitle = "Editar Orden"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @serviceorder.supplier.name
    end
    
    @products_lines = @serviceorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    
    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    respond_to do |format|
      if @serviceorder.update_attributes(params[:serviceorder])
        # Create products for kit
        @serviceorder.delete_products()
        @serviceorder.add_products(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /serviceorders/1
  # DELETE /serviceorders/1.xml
  def destroy
    @serviceorder = Serviceorder.find(params[:id])
    company_id = @serviceorder[:company_id]
    @serviceorder.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/serviceorders/" + company_id.to_s) }
    end
  end
  private
  def serviceorder_params
    params.require(:serviceorder).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id)
  end

end

