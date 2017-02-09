class TrucksController < ApplicationController
  before_action :set_truck, only: [:show, :edit, :update, :destroy]


  def import
      Truck.import(params[:file])
       redirect_to root_url, notice: "Vehiculos importadas."
  end 
  
  # GET /trucks
  # GET /trucks.json
  def index
    @trucks = Truck.all
  end

  # GET /trucks/1
  # GET /trucks/1.json
  def show
    @truck = Truck.new
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()     
  end

  # GET /trucks/new
  def new
    @truck = Truck.new
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()     
  end

  # GET /trucks/1/edit
  def edit
    @truck = Truck.find(params[:id])    
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()
         
  end

  # POST /trucks
  # POST /trucks.json
  def create
    @truck = Truck.new(truck_params)
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()
          

    respond_to do |format|
      if @truck.save
        format.html { redirect_to @truck, notice: 'Truck was successfully created.' }
        format.json { render :show, status: :created, location: @truck }
      else
        format.html { render :new }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trucks/1
  # PATCH/PUT /trucks/1.json
  def update
    respond_to do |format|
      if @truck.update(truck_params)
        format.html { redirect_to @truck, notice: 'Truck was successfully updated.' }
        format.json { render :show, status: :ok, location: @truck }
      else
        format.html { render :edit }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trucks/1
  # DELETE /trucks/1.json
  def destroy
    @truck.destroy
    respond_to do |format|
      format.html { redirect_to trucks_url, notice: 'Truck was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck
      @truck = Truck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def truck_params
      params.require(:truck).permit(:code, :placa, :clase, :marca_id, :modelo_id, :certificado, :ejes, :licencia, :neumatico, :config, :carroceria, :anio, :estado, :propio)
    end
end
