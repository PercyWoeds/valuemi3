class SellvalesController < ApplicationController
  before_action :set_sellvale, only: [:show, :edit, :update, :destroy]

  # GET /sellvales
  # GET /sellvales.json
  def index
    
    if current_user.email == "percywoeds@gmail.com"  || @current_user.level == "parte"  
      
      @sellvales2 = Sellvale.all.where("fecha>=? and fecha<=?","2019-06-01 00:00:00","2019-06-30 23:59:59").order(:fecha,:serie,:numero)
      
        if params[:search_serie]  || params[:search_numero]
          @sellvales = Sellvale.search(params[:search_serie],params[:search_numero]).order(:fecha,:serie,:numero).paginate(:page => params[:page], :per_page => 20)
        else
          @sellvales = Sellvale.all.order(:fecha,:serie,:numero).paginate(:page => params[:page], :per_page => 20)
        end
      
    else
      
      
      if params[:search_serie]  || params[:search_numero]
        
        @sellvales = Sellvale.search(params[:search_serie],params[:search_numero]).where(td:"N").order('fecha DESC').paginate(:page => params[:page], :per_page => 20)
      else
        @sellvales = Sellvale.where(td:"N").order('fecha DESC').paginate(:page => params[:page], :per_page => 20)
      end
      
      
    end 
    
    
     respond_to do |format|
      format.html
      format.csv { send_data @sellvales2.to_csv, filename: "ventas-#{Date.today}.csv" }
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
    @tarjetas = Tarjetum.all 
    @products = Product.all 
    @sellvale[:fecha]  = Date.today
    
    
    
  end

  # GET /sellvales/1/edit
  def edit
    
    @documents = Document.all 
    @employees = Employee.all 
    @customers = Customer.all.order(:name) 
    @creditos = Credito.all
    @tarjetas = Tarjetum.all 
    @products = Product.all 
    
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
    @tarjetas = Tarjetum.all 
    
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
    @tarjetas = Tarjetum.all 
    
    
    @sellvale[:processed] = 0
    
    if @sellvale[:fpago] == 1
      @sellvale[:cod_tar] = '98'
    end
    if @sellvale[:fpago] == 2
      @sellvale[:cod_tar] = '01'
    end
    if @sellvale[:fpago] == 3
      @sellvale[:cod_tar] = '05'
    end
    if @sellvale[:fpago] == 4
      @sellvale[:cod_tar] = '98'
    end
    
    if @sellvale[:fpago] == 5
      @sellvale[:cod_tar] = '06'
    end
    
    respond_to do |format|
      if @sellvale.update(sellvale_params)
        
        
        format.html { redirect_to @sellvale, notice: 'Registro actualizado correctamente.' }
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
  
  def import2
      Sellvale.import2(params[:file2])
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
      params.require(:sellvale).permit(:td, :fecha, :turno, :cod_emp, :caja, :serie, :numero, :cod_cli, :ruc, :placa, :odometro, :cod_prod, :cantidad, :precio, :importe, :igv, :fpago, :dolat, :implista, :cod_tar, :km, :chofer, :tk_devol, :cod_sucu, :isla, :dni_cli, :clear,:tipo,:td)
    end
end
