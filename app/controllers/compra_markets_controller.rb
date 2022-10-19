class CompraMarketsController < ApplicationController
  before_action :set_compra_market, only: [:show, :edit, :update, :destroy]

  # GET /compra_markets
  # GET /compra_markets.json
  def index
    @compra_markets = CompraMarket.all
  end

  # GET /compra_markets/1
  # GET /compra_markets/1.json
  def show
  end

  # GET /compra_markets/new
  def new
    @compra_market = CompraMarket.new
  end

  # GET /compra_markets/1/edit
  def edit
  end

  # POST /compra_markets
  # POST /compra_markets.json
  def create
    @compra_market = CompraMarket.new(compra_market_params)

    respond_to do |format|
      if @compra_market.save
        format.html { redirect_to @compra_market, notice: 'Compra market was successfully created.' }
        format.json { render :show, status: :created, location: @compra_market }
      else
        format.html { render :new }
        format.json { render json: @compra_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compra_markets/1
  # PATCH/PUT /compra_markets/1.json
  def update
    respond_to do |format|
      if @compra_market.update(compra_market_params)
        format.html { redirect_to @compra_market, notice: 'Compra market was successfully updated.' }
        format.json { render :show, status: :ok, location: @compra_market }
      else
        format.html { render :edit }
        format.json { render json: @compra_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compra_markets/1
  # DELETE /compra_markets/1.json
  def destroy
    @compra_market.destroy
    respond_to do |format|
      format.html { redirect_to compra_markets_url, notice: 'Compra market was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
      CompraMarket.import(params[:file])
       redirect_to root_url, notice: "Compras markets importadas."
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compra_market
      @compra_market = CompraMarket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compra_market_params
      params.require(:compra_market).permit(:cod_provdescuento, :preciosigv, :IMPORTE_CONV)
    end
end
