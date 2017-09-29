class TypePayrollsController < ApplicationController
  before_action :set_type_payroll, only: [:show, :edit, :update, :destroy]

  # GET /type_payrolls
  # GET /type_payrolls.json
  def index
    @type_payrolls = TypePayroll.all
  end

  # GET /type_payrolls/1
  # GET /type_payrolls/1.json
  def show
  end

  # GET /type_payrolls/new
  def new
    @type_payroll = TypePayroll.new
  end

  # GET /type_payrolls/1/edit
  def edit
  end

  # POST /type_payrolls
  # POST /type_payrolls.json
  def create
    @type_payroll = TypePayroll.new(type_payroll_params)

    respond_to do |format|
      if @type_payroll.save
        format.html { redirect_to @type_payroll, notice: 'Type payroll was successfully created.' }
        format.json { render :show, status: :created, location: @type_payroll }
      else
        format.html { render :new }
        format.json { render json: @type_payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_payrolls/1
  # PATCH/PUT /type_payrolls/1.json
  def update
    respond_to do |format|
      if @type_payroll.update(type_payroll_params)
        format.html { redirect_to @type_payroll, notice: 'Type payroll was successfully updated.' }
        format.json { render :show, status: :ok, location: @type_payroll }
      else
        format.html { render :edit }
        format.json { render json: @type_payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_payrolls/1
  # DELETE /type_payrolls/1.json
  def destroy
    @type_payroll.destroy
    respond_to do |format|
      format.html { redirect_to type_payrolls_url, notice: 'Type payroll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_payroll
      @type_payroll = TypePayroll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_payroll_params
      params.require(:type_payroll).permit(:code, :descrip)
    end
end
