class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]



  def import
      Employee.import(params[:file])
       redirect_to root_url, notice: "Empleados importadas."
  end 
  
  # GET /employees
  # GET /employees.json
  def index
    
    
    @employees = Employee.paginate(:page => params[:page], :per_page => 20).order(:full_name)
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @categorias =Categorium.all 
    @afps = Afp.all
    @employee.fecha_nacimiento = Date.today
    @employee.fecha_ingreso    = Date.today
    @employee.fecha_cese    = Date.today
     @locations =Location.all
    @divisions =Division.all 
    
  end

  # GET /employees/1/edit
  def edit
    @categorias =Categorium.all 
    @afps = Afp.all
    @employee.fecha_nacimiento = Date.today
    @employee.fecha_ingreso    = Date.today
    @employee.fecha_cese    = Date.today
     @locations =Location.all
    @divisions =Division.all 
    
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    @categorias =Categorium.all 
     @locations =Location.all
    @divisions =Division.all 
    
    @afps = Afp.all
    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
   
    
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:firstname, :lastname, :address1, :address2, :city, :state, :zip, :country, :phone1, :phone2, :email1, :email2, :company_id,:licencia,:idnumber,:active,:afp_id,:onp,:sueldo,:file_nro,:fecha_nacimiento,:fecha_ingreso,:fecha_cese,:sexo_id,:estado_civil_id)
    end
end
