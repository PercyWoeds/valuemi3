class AfericionsController < ApplicationController
  before_action :set_afericion, only: [:show, :edit, :update, :destroy]

  # GET /afericions
  # GET /afericions.json
  def index
    @afericions = Afericion.all
  end

  # GET /afericions/1
  # GET /afericions/1.json
  def show
    @employees = Employee.all
    @islas = Island.all 
    @tanques = Tanque.all 
    
  end

  # GET /afericions/new
  def new
    @afericion = Afericion.new
    @employees = Employee.all
    @islas = Island.all 
    @tanques = Tanque.all 
    @afericion[:fecha] = Date.today
  end

  # GET /afericions/1/edit
  def edit
    @employees = Employee.all
    @islas = Island.all 
    @tanques = Tanque.all 
    
  end

  # POST /afericions
  # POST /afericions.json
  def create
    @afericion = Afericion.new(afericion_params)
    @employees = Employee.all
    @islas = Island.all 
    @tanques = Tanque.all 
    
    respond_to do |format|
      if @afericion.save
        format.html { redirect_to @afericion, notice: 'Afericion was successfully created.' }
        format.json { render :show, status: :created, location: @afericion }
      else
        format.html { render :new }
        format.json { render json: @afericion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /afericions/1
  # PATCH/PUT /afericions/1.json
  def update
    respond_to do |format|
      if @afericion.update(afericion_params)
        format.html { redirect_to @afericion, notice: 'Afericion was successfully updated.' }
        format.json { render :show, status: :ok, location: @afericion }
      else
        format.html { render :edit }
        format.json { render json: @afericion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /afericions/1
  # DELETE /afericions/1.json
  def destroy
    @afericion.destroy
    respond_to do |format|
      format.html { redirect_to afericions_url, notice: 'Afericion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_afericion
      @afericion = Afericion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def afericion_params
      params.require(:afericion).permit(:fecha, :turno, :employee_id, :tanque_id, :documento, :quantity, :importe, :concepto)
    end
end
