class Loans::LoanDetailsController < ApplicationController
  
  
  before_action :set_loan_detail, only: [:show, :edit, :update, :destroy]

  # GET /loan_details
  # GET /loan_details.json
  def index
    @loan_details = LoanDetail.all
  end

  # GET /loan_details/1
  # GET /loan_details/1.json
  def show
  end

  # GET /loan_details/new
  def new
    @loan_detail = LoanDetail.new
    @employee = Employee.all.order(:full_name).where(active:"1")
    @valor = Valor.all
  end

  # GET /loan_details/1/edit
  def edit
    @employee = Employee.all 
    @valor = Valor.all
  end

  # POST /loan_details
  # POST /loan_details.json
  def create
    @loan_detail = LoanDetail.new(loan_detail_params)
    @loan_detail.parameter_id  = @loan.id 
    @employee = Employee.all 
    @valor = Valor.all
    respond_to do |format|
      if @loan_detail.save
        format.html { redirect_to @loan, notice: 'Loan detail was successfully created.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_details/1
  # PATCH/PUT /loan_details/1.json
  def update
    @employee = Employee.all 
    @valor = Valor.all
    
    respond_to do |format|
      if @loan_detail.update(loan_detail_params)
        format.html { redirect_to @loan, notice: 'Loan detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_details/1
  # DELETE /loan_details/1.json
  def destroy
    @loan_detail.destroy
    respond_to do |format|
      format.html { redirect_to loan_details_url, notice: 'Loan detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_loan 
      @loan = Loan.find(params[:parameter_id])
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_detail
      @loan_detail = LoanDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_detail_params
      params.require(:loan_detail).permit(:employee_id, :valor_id, :tm, :detalle)
    end
end
