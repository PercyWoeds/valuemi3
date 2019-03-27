class VentaislasController < ApplicationController
  
  before_action :set_ventaisla, only: [:show, :edit, :update, :destroy]

  # GET /ventaislas
  # GET /ventaislas.json
  def index
    @ventaislas = Ventaisla.order('fecha DESC,turno').paginate(:page => params[:page], :per_page => 20)
    
    

  end

  # GET /ventaislas/1
  # GET /ventaislas/1.json
  def show
    @ventaisla_details= @ventaisla.ventaisla_details
    @employees = Employee.all
    @islas = Island.all
  end

  # GET /ventaislas/new
  def new
    @ventaisla = Ventaisla.new
    @employees = Employee.all
    @islas = Island.all
    @ventaisla[:fecha]= Date.today
  end

  # GET /ventaislas/1/edit
  def edit
    @employees = Employee.all
    @islas = Island.all
  end

  # POST /ventaislas
  # POST /ventaislas.json
  def create
    @ventaisla = Ventaisla.new(ventaisla_params)
    @ventaisla[:island_id] = 1 
    
   @employees = Employee.all 
    respond_to do |format|
      if @ventaisla.save
        format.html { redirect_to @ventaisla, notice: 'Ventaisla was successfully created.' }
        format.json { render :show, status: :created, location: @ventaisla }
      else
        format.html { render :new }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ventaislas/1
  # PATCH/PUT /ventaislas/1.json
  def update
    @ventaisla[:island_id] = 1 
    
    respond_to do |format|
      if @ventaisla.update(ventaisla_params)
        format.html { redirect_to @ventaisla, notice: 'Ventaisla was successfully updated.' }
        format.json { render :show, status: :ok, location: @ventaisla }
      else
        format.html { render :edit }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ventaislas/1
  # DELETE /ventaislas/1.json
  def destroy
    @ventaisla.destroy
    respond_to do |format|
      format.html { redirect_to ventaislas_url, notice: 'Ventaisla was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

 def update_surtidores
    # updates songs based on artist selected
     @surtidores = Pump.find(params[:island_id])
     
  end
  
  def ac_mangueras
    @pumps = Pump.where([" (fuel iLIKE ?  ) ", "%" + params[:q] + "%" ])
    
    render :layout => false
  end
  
  def import
      Ventaisla.import(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 

  def import2
      Ventaisla.import2(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  def import3
      Ventaisla.import3(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  def import4
      Ventaisla.import4(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ventaisla
      @ventaisla = Ventaisla.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ventaisla_params
      params.require(:ventaisla).permit(:fecha, :turno, :employee_id, :pump_id, :importe, :le_an_gln, :le_ac_gln, :galones, :precio_ven,:island_id)
    end
end
