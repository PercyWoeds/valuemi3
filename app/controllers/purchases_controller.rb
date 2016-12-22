include UsersHelper
include SuppliersHelper
include ProductsHelper
include PurchasesHelper

class PurchasesController < ApplicationController
  before_filter :authenticate_user!, :checkProducts

  
  # Export purchase to PDF
  def pdf
    @purchase = Purchase.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/purchases/pdf/#{@purchase.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end



  # Process an purchase
  def do_process
    @purchase = Purchase.find(params[:id])
    @purchase[:processed] = true
    @purchase.process
    
    flash[:notice] = "The purchase order has been processed."
    redirect_to @purchase
  end
  
  # Do send purchase via email
  def do_email
    @purchase = Purchase.find(params[:id])
    @email = params[:email]
    
    Notifier.purchase(@email, @purchase).deliver 
    
    flash[:notice] = "The purchase has been sent successfully."
    redirect_to "/purchases/#{@purchase.id}"
  end
  
  # Send purchase via email
  def email
    @purchase = Purchase.find(params[:id])
    @company = @purchase.company
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
        price2 = price.to_f/1.18
              
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price]    = price.to_f
        product[:discount] = discount.to_f
        product[:price2]   = price2.round(2)

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
    @suppliers =  Supplier.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show purchases for a company
  def list_purchases
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Purchases"
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
        @supplier = Supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier 
          @purchases = Purchase.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchases for that supplier."
          redirect_to "/companies/purchases/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = Supplier.find(params[:supplier])
        
        if @supplier
          @purchases = Purchase.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
       
          flash[:error] = "We couldn't find any purchases for that supplier."
          redirect_to "/companies/purchases/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @purchases = Purchase.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @purchases = Purchase.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @purchases = Purchase.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "documento"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @purchases = Purchase.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @purchases = Purchase.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /purchases
  # GET /purchases.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'purchases'
    @pagetitle = "Purchases"
  end
  
  # GET /purchases/1
  # GET /purchases/1.xml
  def show
    @purchase = Purchase.find(params[:id])
    @supplier = @purchase.supplier
  end

  # GET /purchases/new
  # GET /purchases/new.xml
  
  def new
    @pagetitle = "New purchase"
    @action_txt = "Create"
    
    @purchase = Purchase.new
    
    @purchase[:processed] = false
    
    @company = Company.find(params[:company_id])
    @purchase.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()

    
    @ac_user = getUsername()
    @purchase[:user_id] = getUserId()
  end

  # GET /purchases/1/Edit
  def edit
    @pagetitle = "Editar factura"
    @action_txt = "Actualizacion"
    
    @purchase = Purchase.find(params[:id])
    @company = @purchase.company
    @ac_supplier = @purchase.supplier.name
    @ac_user = @purchase.user.username
    
    @purchase_details = @purchase.purchase_details
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

  end

  # POST /purchases
  # POST /purchases.xml
  def create
    @pagetitle = "Nueva Compra"
    @action_txt = "Crear"
    
    items = params[:items].split(",")
    
    @purchase = Purchase.new(purchase_params)
    
    @company = Company.find(params[:purchase][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
      
    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()


   puts items 


    @purchase[:payable_amount] = @purchase.get_subtotal(items)
    
    begin
      @purchase[:tax_amount] = @purchase.get_tax(items, @purchase[:supplier_id])
    #rescue
    #  @purchase[:tax_amount] = 0
      
    end
    
    @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]
    @purchase[:balance] =   @purchase[:total_amount]
    
    
    if(params[:purchase][:user_id] and params[:purchase][:user_id] != "")
      curr_seller = User.find(params[:purchase][:user_id])

      @ac_user = curr_seller.username
    end    
    

      respond_to do |format|
        if @purchase.save 
          # Create products for kit
          @purchase.add_products(items)
          
          # Check if we gotta process the invoice
          @purchase.process()
          
          format.html { redirect_to(@purchase, :notice => 'Factura fue grabada con exito .') }
          format.xml  { render :xml => @purchase, :status => :created, :location => @purchase}
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
        end
      end
    
    
  end
  

  # PUT /purchases/1
  # PUT /purchases/1.xml
  def update
    @pagetitle = "Edit purchase"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @purchase = purchase.find(params[:id])
    @company = @purchase.company
    
    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()

    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @purchase.supplier.name
    end
    
    @purchase_details = @purchase.purchase_details
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
      
    @purchase[:subtotal] = @purchase.get_subtotal(items)
    @purchase[:tax] = @purchase.get_tax(items, @purchase[:supplier_id])
    @purchase[:total] = @purchase[:subtotal] + @purchase[:tax]

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        # Create products for kit
        @purchase.delete_products()
        @purchase.add_products(items)


        
        # Check if we gotta process the purchase
        @purchase.process()
        
        format.html { redirect_to(@purchase, :notice => 'purchase was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.xml
  def destroy
    @purchase= Purchase.find(params[:id])
    company_id = @purchase[:company_id]
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/purchases/" + company_id.to_s) }
    end
  end
  private
  def purchase_params
    params.require(:purchase).permit(:tank_id,:date1,:date2,:exchange,
      :product_id,:unit_id,:price_with_tax,:price_without_tax,:price_public,:quantity,:other,:money_type,
      :discount,:tax1,:payable_amount,:tax_amount,:total_amount,:status,:pricestatus,:charge,:payment,
      :balance,:tax2,:supplier_id,:order1,:plate_id,:user_id,:company_id,:location_id,:division_id,:comments,
      :processed,:return,:date_processed,:payment_id,:document_id,:documento)
  end

end
