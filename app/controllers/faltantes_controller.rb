class FaltantesController < ApplicationController
  before_action :set_faltante, only: [:show, :edit, :update, :destroy]

  # GET /faltantes
  # GET /faltantes.json
  def index
    @faltantes = Faltante.all
  end

  # GET /faltantes/1
  # GET /faltantes/1.json
  def show
    @employees = Employee.all
    @faltantes = Tipofaltante.all
    
  end

  # GET /faltantes/new
  def new
    @faltante = Faltante.new
    @employees = Employee.all
    @faltantes = Tipofaltante.all
    
  end

  # GET /faltantes/1/edit
  def edit
    @employees = Employee.all
    @faltantes = Tipofaltante.all
    
  end

  # POST /faltantes
  # POST /faltantes.json
  def create
    @faltante = Faltante.new(faltante_params)
    @employees = Employee.all
    @faltantes = Tipofaltante.all
    
    respond_to do |format|
      if @faltante.save
        format.html { redirect_to @faltante, notice: 'Faltante was successfully created.' }
        format.json { render :show, status: :created, location: @faltante }
      else
        format.html { render :new }
        format.json { render json: @faltante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /faltantes/1
  # PATCH/PUT /faltantes/1.json
  def update
    respond_to do |format|
      if @faltante.update(faltante_params)
        format.html { redirect_to @faltante, notice: 'Faltante was successfully updated.' }
        format.json { render :show, status: :ok, location: @faltante }
      else
        format.html { render :edit }
        format.json { render json: @faltante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faltantes/1
  # DELETE /faltantes/1.json
  def destroy
    @faltante.destroy
    respond_to do |format|
      format.html { redirect_to faltantes_url, notice: 'Faltante was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faltante
      @faltante = Faltante.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faltante_params
      params.require(:faltante).permit(:employee_id, :tipofaltante_id, :descrip, :comments,:total,:fecha)
    end
end
