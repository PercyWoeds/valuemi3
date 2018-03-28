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
    @tanques = Tanque.all
  end

  # GET /varillajes/new
  def new
    @varillaje = Varillaje.new
    @tanques = Tanque.all
  end

  # GET /varillajes/1/edit
  def edit
    @tanques = Tanque.all
  end

  # POST /varillajes
  # POST /varillajes.json
  def create
    @tanques = Tanque.all
    @varillaje = Varillaje.new(varillaje_params)
    
    @varillaje[:inicial] = @varillaje.tanque.varilla 
    @varillaje[:compras] = 0
    @varillaje[:directo] = 0
    @varillaje[:consumo] = 0
    @varillaje[:transfe] = 0
    @varillaje[:saldo] = 0
    @varillaje[:dife_dia] = 0
    
    respond_to do |format|
      if @varillaje.save
        
        
        
        @tanque_up = Tanque.find(@varillaje.tanque_id)
        @tanque_up.varilla = @varillaje[:varilla] 
        @tanque_up.save
    
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
        @tanque_up = Tanque.find(@varillaje.tanque_id)
        @tanque_up.varilla = @varillaje[:varilla] 
        @tanque_up.save
    
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
