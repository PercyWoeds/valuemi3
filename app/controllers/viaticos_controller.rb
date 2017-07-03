
include UsersHelper
include CustomersHelper
include ProductsHelper

class ViaticosController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
     
  # Export viatico to PDF
  def pdf
    @viatico = Viatico.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/viaticos/pdf/#{@viatico.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an viatico
  def do_process
    @viatico = Viatico.find(params[:id])
    @viatico[:processed] = "1"
    
    @viatico.process
    
    flash[:notice] = "The viatico order has been processed."
    redirect_to @viatico
  end
  
  # Do send viatico via email
  def do_email
    @viatico = Viatico.find(params[:id])
    @email = params[:email]
    
    Notifier.viatico(@email, @viatico).deliver
    
    flash[:notice] = "The viatico has been sent successfully."
    redirect_to "/viaticos/#{@viatico.id}"
  end

  
  # Send viatico via email
  def email
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
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
  
  # Show viaticos for a company
  def list_viaticos
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Viaticos"
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
         @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @viaticos = Viatico.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /viaticos
  # GET /viaticos.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'viaticos'
    @pagetitle = "viaticos"
  end

  # GET /viaticos/1
  # GET /viaticos/1.xml
  def show
    @viatico = Viatico.find(params[:id])
  end

  # GET /viaticos/new
  # GET /viaticos/new.xml

  
  
  def new
    @pagetitle = "New viatico"
    @action_txt = "Create"
    
    @viatico = Viatico.new
    @viatico[:code] = "I_#{generate_guid()}"
    @viatico[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @viatico.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    
    @ac_user = getUsername()
    @viatico[:user_id] = getUserId()
  end


  # GET /viaticos/1/edit
  def edit
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
    @ac_customer = @viatico.customer.name
    @ac_user = @viatico.user.username
    
    @products_lines = @viatico.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /viaticos
  # POST /viaticos.xml
  def create
    @pagetitle = "New viatico"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @viatico = Viatico.new(viatico_params)
    
    @company = Company.find(params[:viatico][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    begin
      @viatico[:inicial] = @viatico.get_total_inicial(items)
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ing(items)
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal(items)
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
    
    if(params[:viatico][:user_id] and params[:viatico][:user_id] != "")
      curr_seller = User.find(params[:viatico][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @viatico.save
        # Create products for kit
        @viatico.add_products(items)        
        # Check if we gotta process the viatico
        @viatico.process()
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully created.') }
        format.xml  { render :xml => @viatico, :status => :created, :location => @viatico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /viaticos/1
  # PUT /viaticos/1.xml
  def update
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @viatico.customer.name
    end
    
    @products_lines = @viatico.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @viatico[:subtotal] = @viatico.get_subtotal(items)
    @viatico[:tax] = @viatico.get_tax(items, @viatico[:customer_id])
    @viatico[:total] = @viatico[:subtotal] + @viatico[:tax]


    respond_to do |format|
      if @viatico.update_attributes(params[:viatico])
        # Create products for kit
        @viatico.delete_products()
        @viatico.add_products(items)
        
        # Check if we gotta process the viatico
        @viatico.process()
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.xml
  def destroy
    @viatico = Viatico.find(params[:id])
    company_id = @viatico[:company_id]
    @viatico.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/viaticos/" + company_id.to_s) }
    end
  end
  private
  def viatico_params
    params.require(:viatico).permit(:company_id,:code,:fecha1,:inicial,:total_ing,:total_egreso,:saldo,:comments,:user_id,:company_id,:processed,:compro_id)
  end

end

