include UsersHelper
include CustomersHelper
include ProductsHelper



class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  # GET /inventories
  # GET /inventories.json
  def index
    
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'inventories'
    @pagetitle = "Inventories"

  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
     @inventory = Inventory.find(params[:id])
     #@category = @inventory.customer
  end

  # GET /inventories/new
  def new
    
    @pagetitle = "Nuevo inventario "
    @action_txt = "Crear"
    
    @inventory = Inventory.new
    @inventory[:processed] = false
    
    @company = Company.find(params[:company_id])
    @inventory.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @users  = @company.get_users()
    @inventory[:user_id] = getUserId()
  

  end

  # GET /inventories/1/edit
  def edit
    @pagetitle = "Editar inventarios"
    @action_txt = "Update"
    
    @inventory = Inventory.find(params[:id])
    @company = @inventory.company
    @ac_customer = @inventory.customer.name
    @ac_user = @inventory.user.username
    
    @products_lines = @inventory.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /inventories
  # POST /inventories.json
  def create
    
    @pagetitle = "Nuevo inventario "
    @action_txt = "Create"
      
    
    @inventory = Inventory.new(inventory_params)
    
    @company = Company.find(params[:inventory][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()  
    
  
    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory was successfully created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory = Inventory.find(params[:id])
    company_id = @inventory[:company_id]

    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_inventories
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Inventories"
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
      if(params[:ac_category] and params[:ac_category] != "")
        @category  = Category.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_category].strip})
        
        if @category
          @inventories = Inventory.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :category_id => @category.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any inventories for that customer."
          redirect_to "/companies/inventories/#{@company.id}"
        end
      elsif(params[:category] and params[:category] != "")
        @category  = Category.find(params[:category])
        
        if @category
          @inventories = Inventory.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :category_id => @category.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any inventories for that customer."
          redirect_to "/companies/inventories/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @inventories = Inventory.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @inventories = Inventory.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @inventories = Inventory.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @inventories = Inventory.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @inventories = Inventory.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  def pdf
    @inventory = Inventory.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/inventories/pdf/#{@inventory.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an inventory
  def do_process
    @inventory = Inventory.find(params[:id])
    @inventory[:processed] = true
    @inventory.process
    
    flash[:notice] = "The inventory order has been processed."
    redirect_to @inventory
  end
  
  # Do send inventory via email
  def do_email
    @inventory = Inventory.find(params[:id])
    @email = params[:email]
    
    Notifier.inventory(@email, @inventory).deliver
    
    flash[:notice] = "The inventory  has been sent successfully."
    redirect_to "/inventories/#{@inventory.id}"
  end
  
  # Send inventory via email
  def email
    @inventory = Inventory.find(params[:id])
    @company = @inventory.company
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
        puts product.all

        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:curr_total] = total
        
        @products.push(product)
      end
      
      i += 1
    end
    
    render :layout => false
  end
  
  # Autocomplete for product kits
  
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
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end

  def ac_categories
    @categories = ProductsCategory.where(["company_id = ? AND (category LIKE  ?)", params[:company_id], "%" + params[:q] + "%"])
    render :layout => false
  end
  
  def addCategory 

    @inventory.addCategory(params[:addCategory])    

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:company_id, :location_id, :division, :description, :comments, :category_id, :logicalStock, :physicalStock, :cost, :total, :processed, :date_processed, :user_id)
    end

    # Autocomplete for Categories
  
end
