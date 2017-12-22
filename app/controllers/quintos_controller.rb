class QuintosController < ApplicationController
  before_action :set_quinto, only: [:show, :edit, :update, :destroy]

  # GET /quintos
  # GET /quintos.json
  def index
    @quintos = Quinto.all
  end

  # GET /quintos/1
  # GET /quintos/1.json
  def show
    @fives = Fiveparameter.find_by(anio: @quinto.anio)
  end

  # GET /quintos/new
  def new
     
    curr_year = Time.now.year
    c_year = curr_year
    c_month = 1
    @employees= Employee.where(planilla:"1")
    
    @years = []
    @month = Time.now.month
    @months = monthsArr
    @month_name = @months[@month - 1][0]
    
    
    
    while(c_year > Time.now.year - 5)
      @years.push(c_year)
      c_year -= 1
    end
    
    @quinto = Quinto.new
    
    
  end

  # GET /quintos/1/edit
  def edit
    @fives = Fiveparameter.find_by(anio: @quinto.anio)
    
    @employees= Employee.where(planilla:"1")
     curr_year = Time.now.year
    c_year = curr_year
    c_month = 1
    
    @years = []
    @month = Time.now.month
    @months = monthsArr
    @month_name = @months[@month - 1][0]
    
    
    
    while(c_year > Time.now.year - 5)
      @years.push(c_year)
      c_year -= 1
    end
    
  end

  # POST /quintos
  # POST /quintos.json
  def create
    @quinto = Quinto.new(quinto_params)
    
    @quinto.anio = params[:anio]
    @quinto.mes = params[:mes]
    
    
    respond_to do |format|
      if @quinto.save
        format.html { redirect_to @quinto, notice: 'Quinto was successfully created.' }
        format.json { render :show, status: :created, location: @quinto }
      else
        format.html { render :new }
        format.json { render json: @quinto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quintos/1
  # PATCH/PUT /quintos/1.json
  def update
    @quinto.anio = params[:anio]
    @quinto.mes = params[:mes]
    
    
    
    respond_to do |format|
      if @quinto.update(quinto_params)
        format.html { redirect_to @quinto, notice: 'Quinto was successfully updated.' }
        format.json { render :show, status: :ok, location: @quinto }
      else
        format.html { render :edit }
        format.json { render json: @quinto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quintos/1
  # DELETE /quintos/1.json
  def destroy
    @quinto.destroy
    respond_to do |format|
      format.html { redirect_to quintos_url, notice: 'Quinto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quinto
      @quinto = Quinto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quinto_params
      params.require(:quinto).permit(:anio, :employee_id, :mes, :rem_actual, :rem_mes, :asignacion, :hextras, :otros1, :mes_proy, :rem_proyectada, :gratijulio, :gratidic, :bonextra, :otros2, :ene1, :feb1, :mar1, :abr1, :may1, :jun1, :jul1, :ago1, :set1, :oct1, :nov1, :renta_bruta, :deduccion7, :total_renta, :renta_impo1, :renta_impo2, :renta_impo3, :renta_impo4, :renta_impo5, :total_renta_impo, :ene2, :feb2, :mar2, :abr2, :may2, :jun2, :jul2, :ago2, :set2, :oct2, :nov2, :dic2, :renta_impo_ret, :mes_pendiente, :retencion_mensual,:gratijulio1)
    end
end
