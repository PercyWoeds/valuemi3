class PumpsController < ApplicationController
  before_action :set_pump, only: [:show, :edit, :update, :destroy]

  # GET /pumps
  # GET /pumps.json
  def index
    @pumps = Pump.all
  end

  # GET /pumps/1
  # GET /pumps/1.json
  def show
    @products = Product.where(products_category_id: 1)
    @tanques = Tanque.all
    @islas = Island.all
  end

  # GET /pumps/new
  def new
    @pump = Pump.new
    @products = Product.where(products_category_id: 1)
    @tanques = Tanque.all
    @islas = Island.all
    
    @pump[:le_ac_gln] = 0 
    @pump[:le_an_gln] = 0 
  end

  # GET /pumps/1/edit
  def edit
    @products = Product.where(products_category_id: 1)
    @tanques = Tanque.all
    @islas = Island.all
  end

  # POST /pumps
  # POST /pumps.json
  def create
    @pump = Pump.new(pump_params)
  @products = Product.where(products_category_id: 1)
  @tanques = Tanque.all
  @islas = Island.all
    respond_to do |format|
      if @pump.save
        format.html { redirect_to @pump, notice: 'Pump was successfully created.' }
        format.json { render :show, status: :created, location: @pump }
      else
        format.html { render :new }
        format.json { render json: @pump.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pumps/1
  # PATCH/PUT /pumps/1.json
  def update
    respond_to do |format|
      if @pump.update(pump_params)
        format.html { redirect_to @pump, notice: 'Pump was successfully updated.' }
        format.json { render :show, status: :ok, location: @pump }
      else
        format.html { render :edit }
        format.json { render json: @pump.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pumps/1
  # DELETE /pumps/1.json
  def destroy
    @pump.destroy
    respond_to do |format|
      format.html { redirect_to pumps_url, notice: 'Pump was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pump
      @pump = Pump.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pump_params
      params.require(:pump).permit(:fuel, :pump01, :product_id, :price_buy, :price_sell, :le_an_gln, :le_ac_gln, :gln, :date1, :employee_id, :turno,:tanque_id,:island_id)
    end
end
