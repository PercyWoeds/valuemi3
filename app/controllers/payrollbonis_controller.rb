class PayrollbonisController < ApplicationController
  before_action :set_payrollboni, only: [:show, :edit, :update, :destroy]

  # GET /payrollbonis
  # GET /payrollbonis.json
  def index
    @payrollbonis = Payrollboni.all
    @company = Company.find(1)
  end

  # GET /payrollbonis/1
  # GET /payrollbonis/1.json
  def show
    @parametros = Valor.all
    @payrolls = Payroll.all
    @employees = Employee.where(:planilla=> "1")
    @tms =Tm.all
  end

  # GET /payrollbonis/new
  def new
    @parametros = Valor.all 
    @payrolls = Payroll.all 
    @payrollboni = Payrollboni.new
    @employees = Employee.where(:planilla=> "1").order(:lastname)
    @tms =Tm.all
  end

  # GET /payrollbonis/1/edit
  def edit
    @parametros = Valor.all 
    @payrolls = Payroll.all
    @tms =Tm.all
    
    @employees = Employee.where(:active=> "1")
  end

  # POST /payrollbonis
  # POST /payrollbonis.json
  def create
    
    @payrollboni = Payrollboni.new(payrollboni_params)
    
    @payrolls=Payroll.all 
    @tms =Tm.all
    @employees = Employee.where(:planilla=> "1")
    @parametros = Valor.all
    puts "payroll id "
    puts @payrollboni.payroll_id
    respond_to do |format|
      if @payrollboni.save
        format.html { redirect_to(@payrollboni, :notice => 'Formulario fue creado satisfactoriamente.') }
        format.xml  { render :xml => @payrollboni, :status => :created, :location => @payrollboni }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payrollboni.errors, :status => :unprocessable_entity }
      end
    
    end
  end

  # PATCH/PUT /payrollbonis/1
  # PATCH/PUT /payrollbonis/1.json
  def update
    respond_to do |format|
      if @payrollboni.update(payrollboni_params)
        format.html { redirect_to @payrollboni, notice: 'Payrollboni was successfully updated.' }
        format.json { render :show, status: :ok, location: @payrollboni }
      else
        format.html { render :edit }
        format.json { render json: @payrollboni.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrollbonis/1
  # DELETE /payrollbonis/1.json
  def destroy
    @payrollboni.destroy
    respond_to do |format|
      format.html { redirect_to payrollbonis_url, notice: 'Payrollboni was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payrollboni
      @payrollboni = Payrollboni.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payrollboni_params
      params.require(:payrollboni).permit(:importe,:valor_id,:payroll_id,:employee_id,:tm_id)
    end
end
