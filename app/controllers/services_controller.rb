class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
# Autocomplete for products
  def ac_services
    @products = Service.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
    render :layout => false
  end
 # List products for a company
  def list_products
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Products"
  
    if(@company.can_view(current_user))
      if(params[:restock])
        @products = Product.where(["company_id = ? AND quantity <= reorder", @company.id]).paginate(:page => params[:page])
        @view_restock = true
      else
        if(params[:q] and params[:q] != "")
          fields = ["name", "code", "category", "description", "comments"]
        
          q = params[:q].strip
          @q_org = q
        
          query = str_sql_search(q, fields)
        
          @products = Product.where(["company_id = ? AND (#{query})", @company.id]).paginate(:page => params[:page]) 
        else
          @products = Product.where(company_id: @company.id).paginate(:page => params[:page])
        end
      end
    else
      errPerms()
    end
  end
  

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:code, :name, :cost, :price, :tax1_name, :tax1, :quantity, :description, :comments, :company_id, :discount, :currtotal)
    end
end
