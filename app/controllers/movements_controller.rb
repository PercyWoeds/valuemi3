include UsersHelper
include SuppliersHelper
include ProductsHelper

class MovementsController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
  
  
  # Export movement to PDF
  def pdf
    @movement = Movement.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/movements/pdf/#{@movement.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an movement
  def do_process
    @movement = Movement.find(params[:id])
    @movement[:processed] = true
    
    @movement.process
    
    flash[:notice] = "The movement order has been processed."
    redirect_to @movement
  end
  
  # Do send movement via email
  def do_email
    @movement = Movement.find(params[:id])
    @email = params[:email]
    
    Notifier.movement(@email, @movement).deliver
    
    flash[:notice] = "The movement has been sent successfully."
    redirect_to "/movements/#{@movement.id}"
  end
  
  # Send movement via email
  def email
    @movement = Movement.find(params[:id])
    @company = @movement.company
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
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:CurrTotal] = total
        
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
    @suppliers = supplier.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show movements for a company
  def list_movements
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - movements"
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
          @movements = Movement.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any movements for that supplier."
          redirect_to "/companies/movements/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @movements = Movement.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any movements for that supplier."
          redirect_to "/companies/movements/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @movements = Movement.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @movements = Movement.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @movements = Movement.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @movements = Movement.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @movements = Movement.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /movements
  # GET /movements.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'movements'
    @pagetitle = "movements"
  end

  # GET /movements/1
  # GET /movements/1.xml
  def show
    @movement = Movement.find(params[:id])
    @supplier = @movement.supplier
  end

  # GET /movements/new
  # GET /movements/new.xml
  
  def new
    @pagetitle = "New movement"
    @action_txt = "Create"
    
    @movement = Movement.new
    @movement[:code] = "I_#{generate_guid()}"
    @movement[:processed] = false
    
    @company = Company.find(params[:company_id])
    @movement.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    
    @ac_user = getUsername()
    @movement[:user_id] = getUserId()
  end

  # GET /movements/1/edit
  def edit
    @pagetitle = "Edit movement"
    @action_txt = "Update"
    
    @movement = Movement.find(params[:id])
    @company = @movement.company
    @ac_supplier = @movement.supplier.name
    @ac_user = @movement.user.username
    
    @products_lines = @movement.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /movements
  # POST /movements.xml
  def create
    @pagetitle = "New movement"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @movement = Movement.new(movement_params)
    
    @company = Company.find(params[:movement][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @movement[:subtotal] = @movement.get_subtotal(items)
    
    begin
      @movement[:tax] = @movement.get_tax(items, @movement[:supplier_id])
    rescue
      @movement[:tax] = 0
    end
    
    @movement[:total] = @movement[:subtotal] + @movement[:tax]
    
    if(params[:movement][:user_id] and params[:movement][:user_id] != "")
      curr_seller = User.find(params[:movement][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @movement.save
        # Create products for kit
        @movement.add_products(items)
        
        # Check if we gotta process the movement
        @movement.process()
        
        format.html { redirect_to(@movement, :notice => 'movement was successfully created.') }
        format.xml  { render :xml => @movement, :status => :created, :location => @movement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movement.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /movements/1
  # PUT /movements/1.xml
  def update
    @pagetitle = "Edit movement"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @movement = Movement.find(params[:id])
    @company = @movement.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @movement.supplier.name
    end
    
    @products_lines = @movement.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @movement[:subtotal] = @movement.get_subtotal(items)
    @movement[:tax] = @movement.get_tax(items, @movement[:supplier_id])
    @movement[:total] = @movement[:subtotal] + @movement[:tax]

    respond_to do |format|
      if @movement.update_attributes(params[:movement])
        # Create products for kit
        @movement.delete_products()
        @movement.add_products(items)
        
        # Check if we gotta process the movement
        @movement.process()
        
        format.html { redirect_to(@movement, :notice => 'movement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movements/1
  # DELETE /movements/1.xml
  def destroy
    @movement = Movement.find(params[:id])
    company_id = @movement[:company_id]
    @movement.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/movements/" + company_id.to_s) }
    end
  end
  private
  def movement_params
    params.require(:movement).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id)
  end

end

