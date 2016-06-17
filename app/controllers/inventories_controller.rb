class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /inventories
  # GET /inventories.json
  def index
    @inventories = Inventory.all
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

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
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_inventories   
      @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Invoices"
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
          @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any invoices for that customer."
          redirect_to "/companies/invoices/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any invoices for that customer."
          redirect_to "/companies/invoices/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @invoices = Invoice.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @invoices = Invoice.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end

   end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:category_id, :tot_logical, :tot_physical, :comments)
    end
end
