class MarketsController < ApplicationController
  before_action :set_market, only: [:show, :edit, :update, :destroy]

  # GET /markets
  # GET /markets.json
  def index
    if params[:search]
        @markets = Market.search(params[:search]).order('fecha DESC,serie,numero').paginate(:page => params[:page], :per_page => 20)
      else
        @markets = Market.order('fecha DESC,serie,numero').paginate(:page => params[:page], :per_page => 20)
      end
      
  end

  # GET /markets/1
  # GET /markets/1.json
  def show
  end

  # GET /markets/new
  def new
    @market = Market.new
  end

  # GET /markets/1/edit
  def edit
  end

  # POST /markets
  # POST /markets.json
  def create
    @market = Market.new(market_params)

    respond_to do |format|
      if @market.save
        format.html { redirect_to @market, notice: 'Market was successfully created.' }
        format.json { render :show, status: :created, location: @market }
      else
        format.html { render :new }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /markets/1
  # PATCH/PUT /markets/1.json
  def update
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to @market, notice: 'Market was successfully updated.' }
        format.json { render :show, status: :ok, location: @market }
      else
        format.html { render :edit }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.json
  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to markets_url, notice: 'Market was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def import
       Market.import(params[:file])
       redirect_to root_url, notice: "Ventas importadas."
  end 
  
 def do_process
      
       @market = Market.last 

        
       @market.process2

       redirect_to root_url, notice: "Ventas importadas."

 end 
def do_process2
      
       @market = Market.last 

        
       @market.process3

       redirect_to root_url, notice: "Ventas importadas."

 end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market
      @market = Market.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_params
      params.require(:market).permit(:order_id, :td, :fecha, :turno, :cod_emp, :caja, :serie, :numero, :cod_cli, :ruc, :placa, :odometro, :cod_prod, :cod_prod, :cantidad, :precio, :importe, :igv, :fpago, :dolar, :cod_dep, :cod_lin, :cod_tar, :dolares, :precio1, :margen,:descrip )
    end
end
