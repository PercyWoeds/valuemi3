
include UsersHelper
include CustomersHelper
include ProductsHelper

class LgvsController < ApplicationController
    
    before_filter :authenticate_user!, :checkProducts
     
  # Export lgv to PDF
  def pdf
    @lgv = Lgv.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/lgvs/pdf/#{@lgv.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an lgv
  def do_process
    @lgv = Lgv.find(params[:id])
    @lgv[:processed] = "1"
    
    @lgv.process
    
    flash[:notice] = "The lgv order has been processed."
    redirect_to @lgv
  end
  
  # Do send lgv via email
  def do_email
    @lgv = Lgv.find(params[:id])
    @email = params[:email]
    
    Notifier.lgv(@email, @lgv).deliver
    
    flash[:notice] = "The lgv has been sent successfully."
    redirect_to "/lgvs/#{@lgv.id}"
  end

  
  # Send lgv via email
  def email
    @lgv = Lgv.find(params[:id])
    @company = @lgv.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    @total_pago1= 0
    i = 0
    total = 0 
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        detalle = parts[2]
        inicial = parts[4]
        puts  "inicial"
        puts inicial  
        
        product = Compro.find(id.to_i)
        product[:i] = i
        product[:importe] = quantity.to_f
        product[:detalle] = detalle
        
        total += product[:importe]
        
        product[:CurrTotal] = total
        
        @total_pago1  = total     
        
        @products.push(product)
        
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  # Autocomplete for documento
  def ac_documentos
    @products = Compro.where(["company_id = ? AND code LIKE ? ", params[:company_id], "%" + params[:q] + "%"])
    
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
  
  # Show lgvs for a company
  def list_lgvs
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - lgvs"
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
         @lgvs = Lgv.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @lgvs = Lgv.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @lgvs = Lgv.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /lgvs
  # GET /lgvs.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'lgvs'
    @pagetitle = "lgvs"
  end

  # GET /lgvs/1
  # GET /lgvs/1.xml
  def show
    @lgv = Lgv.find(params[:id])
  end

  # GET /lgvs/new
  # GET /lgvs/new.xml

  
  
  def new
    @pagetitle = "New lgv"
    @action_txt = "Create"
    
    @lgv = Lgv.new
    @lgv[:code] = "I_#{generate_guid()}"
    @lgv[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @lgv.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
     @transports = @company.get_transports()
    @gastos = Gasto.all 
    
    @ac_user = getUsername()
    @lgv[:user_id] = getUserId()
  end


  # GET /lgvs/1/edit
  def edit
    @pagetitle = "Edit lgv"
    @action_txt = "Update"
    
    @lgv = Lgv.find(params[:id])
    @company = @lgv.company
    @ac_customer = @lgv.customer.name
    @ac_user = @lgv.user.username
    
    @products_lines = @lgv.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /lgvs
  # POST /lgvs.xml
  def create
    @pagetitle = "New lgv"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @lgv = Lgv.new(lgv_params)
    
    @company = Company.find(params[:lgv][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    begin
      @lgv[:inicial] = @lgv.get_total_inicial(items)
    rescue
      @lgv[:inicial] = 0
    end 
    
    begin
      @lgv[:total_ing] = @lgv.get_total_ing(items)
    rescue 
      @lgv[:total_ing] = 0
    end 
    begin 
      @lgv[:total_egreso]=  @lgv.get_total_sal(items)
    rescue 
      @lgv[:total_egreso]= 0 
    end 
    @lgv[:saldo] = @lgv[:inicial] +  @lgv[:total_ing] - @lgv[:total_egreso]
    
    if(params[:lgv][:user_id] and params[:lgv][:user_id] != "")
      curr_seller = User.find(params[:lgv][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @lgv.save
        # Create products for kit
        @lgv.add_products(items)        
        # Check if we gotta process the lgv
        @lgv.process()
        
        format.html { redirect_to(@lgv, :notice => 'lgv was successfully created.') }
        format.xml  { render :xml => @lgv, :status => :created, :location => @lgv }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lgv.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /lgvs/1
  # PUT /lgvs/1.xml
  def update
    @pagetitle = "Edit lgv"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @lgv = Lgv.find(params[:id1])
    @company = @lgv.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @lgv.customer.name
    end
    
    @products_lines = @lgv.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @lgv[:subtotal] = @lgv.get_subtotal(items)
    @lgv[:tax] = @lgv.get_tax(items, @lgv[:customer_id])
    @lgv[:total] = @lgv[:subtotal] + @lgv[:tax]


    respond_to do |format|
      if @lgv.update_attributes(params[:lgv])
        # Create products for kit
        @lgv.delete_products()
        @lgv.add_products(items)
        
        # Check if we gotta process the lgv
        @lgv.process()
        
        format.html { redirect_to(@lgv, :notice => 'lgv was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lgv.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lgvs/1
  # DELETE /lgvs/1.xml
  def destroy
    @lgv = Lgv.find(params[:id])
    company_id = @lgv[:company_id]
    @lgv.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/lgvs/" + company_id.to_s) }
    end
  end
  
  private
  def lgv_params
    params.require(:lgv).permit(:company_id,:code,:tranportorder_id,:fecha,:viatico_id,:total,:devuelto_texto,:devuelto,:reembolso,:descuento,:observa)
  end

end


