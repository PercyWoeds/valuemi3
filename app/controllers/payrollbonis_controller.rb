class PayrollbonisController < ApplicationController
  before_action :set_payrollboni, only: [:show, :edit, :update, :destroy]

  # GET /payrollbonis
  # GET /payrollbonis.json
  def index
    @payrollbonis = Payrollboni.all
  end

  # GET /payrollbonis/1
  # GET /payrollbonis/1.json
  def show
    @parametros = Valor.all 
  end

  # GET /payrollbonis/new
  def new
    @parametros = Valor.all 
    @payrollboni = Payrollboni.new
  end

  # GET /payrollbonis/1/edit
  def edit
    @parametros = Valor.all 
  end

  # POST /payrollbonis
  # POST /payrollbonis.json
  def create
    
    @payrollboni = Payrollboni.new(payrollboni_params)
  
    respond_to do |format|
      if @payrollboni.save
        format.html { redirect_to @payrollboni, notice: 'Payrollboni was successfully created.' }
        format.json { render :show, status: :created, location: @payrollboni }
      else
        format.html { render :new }
        format.json { render json: @payrollboni.errors, status: :unprocessable_entity }
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
      params.require(:payrollboni).permit(:code, :descrip, :importe,:valor_id,:payroll_id)
    end
end
