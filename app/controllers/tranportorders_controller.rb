class TranportordersController < ApplicationController
  before_action :set_tranportorder, only: [:show, :edit, :update, :destroy]

  # GET /tranportorders
  # GET /tranportorders.json
  def index
    @tranportorders = Tranportorder.all
  end

  # GET /tranportorders/1
  # GET /tranportorders/1.json
  def show
  end

  # GET /tranportorders/new
  def new
    @tranportorder = Tranportorder.new

    @customers = @tranportorder.get_customers()
    @puntos =    @tranportorder.get_puntos()
    @employees = Employee.all 
    @trucks = Truck.all 
    @tranportorder[:code] = "#{generate_guid6()}"
    @locations = Location.all
    @divisions = Division.all 
  
  end

  # GET /tranportorders/1/edit
  def edit
     @customers = @tranportorder.get_customers()
     @puntos = @tranportorder.get_puntos()
     @employees = Employee.all 
     @trucks = Truck.all 
     @locations = Location.all
     @divisions = Division.all 
  
  end

  # POST /tranportorders
  # POST /tranportorders.json
  def create
    @tranportorder = Tranportorder.new(tranportorder_params)
    @customers = @tranportorder.get_customers()
    @puntos = @tranportorder.get_puntos()
    @employees = Employee.all 
    @trucks = Truck.all 
    @locations = Location.all
    @divisions = Division.all 

    @tranportorder[:user_id] = @current_user.id
    @tranportorder[:company_id] = 1
    @tranportorder[:processed] = "1"

    respond_to do |format|
      if @tranportorder.save
         @tranportorder.correlativo

        format.html { redirect_to @tranportorder, notice: 'Tranportorder was successfully created.' }
        format.json { render :show, status: :created, location: @tranportorder }
      else
        format.html { render :new }
        format.json { render json: @tranportorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tranportorders/1
  # PATCH/PUT /tranportorders/1.json
  def update
    respond_to do |format|
      if @tranportorder.update(tranportorder_params)
        format.html { redirect_to @tranportorder, notice: 'Tranportorder was successfully updated.' }
        format.json { render :show, status: :ok, location: @tranportorder }
      else
        format.html { render :edit }
        format.json { render json: @tranportorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tranportorders/1
  # DELETE /tranportorders/1.json
  def destroy
    @tranportorder.destroy
    respond_to do |format|
      format.html { redirect_to tranportorders_url, notice: 'Tranportorder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tranportorder
      @tranportorder = Tranportorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tranportorder_params
      params.require(:tranportorder).permit(:code, :employee_id, :truck_id, :employee2_id, :truck2_id, :ubication_id, :ubication2_id, :fecha1, :fecha2, :description, :comments, :processed, :company_id, :location_id, :division_id)
    end
end
