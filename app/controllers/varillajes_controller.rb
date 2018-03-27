class VarillajesController < ApplicationController
  before_action :set_varillaje, only: [:show, :edit, :update, :destroy]

  # GET /varillajes
  # GET /varillajes.json
  def index
    @varillajes = Varillaje.all
  end

  # GET /varillajes/1
  # GET /varillajes/1.json
  def show
  end

  # GET /varillajes/new
  def new
    @varillaje = Varillaje.new
  end

  # GET /varillajes/1/edit
  def edit
  end

  # POST /varillajes
  # POST /varillajes.json
  def create
    @varillaje = Varillaje.new(varillaje_params)

    respond_to do |format|
      if @varillaje.save
        format.html { redirect_to @varillaje, notice: 'Varillaje was successfully created.' }
        format.json { render :show, status: :created, location: @varillaje }
      else
        format.html { render :new }
        format.json { render json: @varillaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /varillajes/1
  # PATCH/PUT /varillajes/1.json
  def update
    respond_to do |format|
      if @varillaje.update(varillaje_params)
        format.html { redirect_to @varillaje, notice: 'Varillaje was successfully updated.' }
        format.json { render :show, status: :ok, location: @varillaje }
      else
        format.html { render :edit }
        format.json { render json: @varillaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /varillajes/1
  # DELETE /varillajes/1.json
  def destroy
    @varillaje.destroy
    respond_to do |format|
      format.html { redirect_to varillajes_url, notice: 'Varillaje was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_varillaje
      @varillaje = Varillaje.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def varillaje_params
      params.require(:varillaje).permit(:tanque_id, :product_id, :inicial, :compras, :directo, :consumo, :transfe, :saldo, :varilla, :dife_dia, :fecha, :documento)
    end
end
