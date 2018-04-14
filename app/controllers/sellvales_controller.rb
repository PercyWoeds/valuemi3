class SellvalesController < ApplicationController
  before_action :set_sellvale, only: [:show, :edit, :update, :destroy]

  # GET /sellvales
  # GET /sellvales.json
  def index
    
    if current_user.email == "percywoeds@gmail.com"
      @sellvales = Sellvale.all.order(:fecha,:serie,:numero).paginate(:page => params[:page], :per_page => 20)
    else   
      @sellvales = Sellvale.where(td:"N").order('fecha DESC').paginate(:page => params[:page], :per_page => 20)
    end 
  end

  # GET /sellvales/1
  # GET /sellvales/1.json
  def show
  end

  # GET /sellvales/new
  def new
    @sellvale = Sellvale.new
    
    @documents = Document.all 
    @employees = Employee.all 
    @customers = Customer.all 
    @creditos = Credito.all
    @products = Product.where(products_category_id:1)
    @sellvale[:fecha]  = Date.today
    
    
    
  end

  # GET /sellvales/1/edit
  def edit
    
    @documents = Document.all 
    @employees = Employee.all 
    @customers = Customer.all 
    @creditos = Credito.all
    @products = Product.where(products_category_id:1)
    
  end

  # POST /sellvales
  # POST /sellvales.json
  def create
    @sellvale = Sellvale.new(sellvale_params)

    @documents = Document.all 
    @employees = Employee.all 
    @customers = Customer.all 
    @creditos = Credito.all
    @products = Product.where(products_category_id:1)
    
    @sellvale[:fpago] = 1
    @sellvale[:td] = "N"
    @sellvale[:implista] = 0
    @sellvale[:processed] = 0
    
    lcImporte = @sellvale[:cantidad] *@sellvale[:precio].to_f 
    @sellvale[:importe] = lcImporte.to_s
    
    
    respond_to do |format|
      if @sellvale.save
        format.html { redirect_to @sellvale, notice: 'Sellvale was successfully created.' }
        format.json { render :show, status: :created, location: @sellvale }
      else
        format.html { render :new }
        format.json { render json: @sellvale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sellvales/1
  # PATCH/PUT /sellvales/1.json
  def update
    @documents = Document.all 
    @employees = Employee.all 
    @customers = Customer.all 
    @creditos = Credito.all
    @products = Product.where(products_category_id:1)
    @sellvale[:fpago] = 1
    
    
    @sellvale[:processed] = 0
    
    @sellvale[:importe] = @sellvale[:precio].to_f * @sellvale[:cantidad] 
    
    respond_to do |format|
      if @sellvale.update(sellvale_params)
        format.html { redirect_to @sellvale, notice: 'Sellvale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sellvale }
      else
        format.html { render :edit }
        format.json { render json: @sellvale.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
      Sellvale.import(params[:file])
       redirect_to root_url, notice: "Ventas importadas."
  end 

  # DELETE /sellvales/1
  # DELETE /sellvales/1.json
  def destroy
    @sellvale.destroy
    respond_to do |format|
      format.html { redirect_to sellvales_url, notice: 'Sellvale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sellvale
      @sellvale = Sellvale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sellvale_params
      params.require(:sellvale).permit(:td, :fecha, :turno, :cod_emp, :caja, :serie, :numero, :cod_cli, :ruc, :placa, :odometro, :cod_prod, :cantidad, :precio, :importe, :igv, :fpago, :dolat, :implista, :cod_tar, :km, :chofer, :tk_devol, :cod_sucu, :isla, :dni_cli, :clear,:tipo)
    end
end
