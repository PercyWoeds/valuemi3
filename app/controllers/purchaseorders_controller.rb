
include UsersHelper
include SuppliersHelper
include ProductsHelper

class PurchaseordersController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
    
  
  # Export purchaseorder to PDF
  def pdf
    @purchaseorder = Purchaseorder.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/purchaseorders/pdf/#{@purchaseorder.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
       
  def populate_order

    for cart_item in @cart.cart_items
    order_item = Item.new(  
    :product_id => cart_item.id,
    :description => cart_item.name,
    :quantity => cart_item.quantity,
    :qty      => cart_item.qty,
    :recibir  => cart_item.recibir
    )

    @purchaseorder.purchaseorder_details << order_item
    end
  end


  def do_grabar_ins
    @purchaseorder = Purchaseorder.find(params[:id])    

    populate_order
    
    flash[:notice] = "The purchaseorder order has been grabada."
    redirect_to @purchaseorder
  end
  # Process an purchaseorder
  def do_process
    @purchaseorder = Purchaseorder.find(params[:id])
    @purchaseorder[:processed] = "1"
    
    @purchaseorder.process
    
    flash[:notice] = "The purchaseorder order has been processed."
    redirect_to @purchaseorder
  end
  
  # Do send purchaseorder via email
  def do_email
    @purchaseorder = Purchaseorder.find(params[:id])
    @email = params[:email]
    
    Notifier.purchaseorder(@email, @purchaseorder).deliver
    
    flash[:notice] = "The purchaseorder has been sent successfully."
    redirect_to "/purchaseorders/#{@purchaseorder.id}"
  end
  
  # Send purchaseorder via email
  def email
    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company
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
  
  # Show purchaseorders for a company
  def list_purchaseorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Orden Compra"
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
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @purchaseorders = Purchaseorder.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  # Show purchaseorders for a company
  def list_receiveorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Orden Compra"
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
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @purchaseorders = Purchaseorder.where(company_id:  @company.id, :processed => "1").order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /purchaseorders
  # GET /purchaseorders.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'purchaseorders'
    @pagetitle = "purchaseorders"
  end

  # GET /purchaseorders/1
  # GET /purchaseorders/1.xml
  def show
    @purchaseorder = Purchaseorder.find(params[:id])
    @supplier = @purchaseorder.supplier
  end

  def receive
    @purchaseorder = Purchaseorder.find(params[:id])
    @supplier = @purchaseorder.supplier
    @company = Company.find(@purchaseorder.company_id)
    @documents =@company.get_documents()
  end

  # GET /purchaseorders/new
  # GET /purchaseorders/new.xml
  
  def new
    @pagetitle = "Nueva Orden Compra"
    @action_txt = "Create"
    
    @purchaseorder = Purchaseorder.new
    @purchaseorder[:code] = "I_#{generate_guid()}"
    @purchaseorder[:processed] = false
    
    @company = Company.find(params[:company_id])
    @purchaseorder.company_id = @company.id
        
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()
    @monedas  = @company.get_monedas()
        
    @ac_user = getUsername()
    @purchaseorder[:user_id] = getUserId()
  end

  # GET /purchaseorders/1/edit
  def edit
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"
    
    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company
    @ac_supplier = @purchaseorder.supplier.name
    @ac_user = @purchaseorder.user.username
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()    
    @monedas  = @company.get_monedas()
    
    @products_lines = @purchaseorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /purchaseorders
  # POST /purchaseorders.xml
  def create
    @pagetitle = "Nueve Orden de Compra"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @purchaseorder = Purchaseorder.new(purchaseorder_params)
    
    @company = Company.find(params[:purchaseorder][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @monedas  = @company.get_monedas()

    @purchaseorder[:subtotal] = @purchaseorder.get_subtotal(items)
    
    begin
      @purchaseorder[:tax] = @purchaseorder.get_tax(items, @purchaseorder[:supplier_id])
    rescue
      @purchaseorder[:tax] = 0
    end
    
    @purchaseorder[:total] = @purchaseorder[:subtotal] + @purchaseorder[:tax]
    
    if(params[:purchaseorder][:user_id] and params[:purchaseorder][:user_id] != "")
      curr_seller = User.find(params[:purchaseorder][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @purchaseorder.save
        # Create products for kit
        @purchaseorder.add_products(items)        
        # Check if we gotta process the purchaseorder
        @purchaseorder.process()
        
        format.html { redirect_to(@purchaseorder, :notice => 'purchaseorder was successfully created.') }
        format.xml  { render :xml => @purchaseorder, :status => :created, :location => @purchaseorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchaseorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /purchaseorders/1
  # PUT /purchaseorders/1.xml
  def update
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @purchaseorder.supplier.name
    end
    
    @products_lines = @purchaseorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    
    @monedas  = @company.get_monedas()
    
    @purchaseorder[:subtotal] = @purchaseorder.get_subtotal(items)
    @purchaseorder[:tax]      = @purchaseorder.get_tax(items, @purchaseorder[:supplier_id])
    @purchaseorder[:total]    = @purchaseorder[:subtotal] + @purchaseorder[:tax]

    respond_to do |format|
      if @purchaseorder.update_attributes(params[:purchaseorder])
        # Create products for kit
        @purchaseorder.delete_products()
        @purchaseorder.add_products(items)
        # Check if we gotta process the purchaseorder
        @purchaseorder.process()
        
        format.html { redirect_to(@purchaseorder, :notice => 'purchaseorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchaseorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchaseorders/1
  # DELETE /purchaseorders/1.xml
  def destroy
    @purchaseorder = Purchaseorder.find(params[:id])
    company_id = @purchaseorder[:company_id]
    @purchaseorder.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/purchaseorders/" + company_id.to_s) }
    end
  end
  private
  def purchaseorder_params
    params.require(:purchaseorder).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:moneda_id)
  end

end

