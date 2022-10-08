class TipocambiosController < ApplicationController
  before_action :set_tipocambio, only: [:show, :edit, :update, :destroy]

  # GET /tipocambios
  # GET /tipocambios.json
  def index
   
    start_date = params.fetch(:start_date, Date.today).to_date
  @tipocambios = Tipocambio.where(dia: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)

  end

  # GET /tipocambios/1
  # GET /tipocambios/1.json
  def show
  end

  # GET /tipocambios/new
  def new
    @tipocambio = Tipocambio.new
  end

  # GET /tipocambios/1/edit
  def edit
  end

  # POST /tipocambios
  # POST /tipocambios.json
  def create
    @tipocambio = Tipocambio.new(tipocambio_params)

    respond_to do |format|
      if @tipocambio.save
        format.html { redirect_to @tipocambio, notice: 'Tipocambio was successfully created.' }
        format.json { render :show, status: :created, location: @tipocambio }
      else
        format.html { render :new }
        format.json { render json: @tipocambio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipocambios/1
  # PATCH/PUT /tipocambios/1.json
  def update
    respond_to do |format|
      if @tipocambio.update(tipocambio_params)
        format.html { redirect_to @tipocambio, notice: 'Tipocambio was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipocambio }
      else
        format.html { render :edit }
        format.json { render json: @tipocambio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipocambios/1
  # DELETE /tipocambios/1.json
  def destroy
    @tipocambio.destroy
    respond_to do |format|
      format.html { redirect_to tipocambios_url, notice: 'Tipocambio was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def import
      Tipocambio.import(params[:file])
       redirect_to root_url, notice: "Tipo cambio importadas."
  end 
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipocambio
      @tipocambio = Tipocambio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipocambio_params
      params.require(:tipocambio).permit(:dia, :compra, :venta)
    end
end
