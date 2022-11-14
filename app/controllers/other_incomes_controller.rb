class OtherIncomesController < ApplicationController
  before_action :set_other_income, only: [:show, :edit, :update, :destroy]

  # GET /other_incomes
  # GET /other_incomes.json
  def index
    @other_incomes = OtherIncome.order(:fecha).paginate(:page => params[:page], :per_page => 20)
  end

  # GET /other_incomes/1
  # GET /other_incomes/1.json
  def show
  end

  # GET /other_incomes/new
  def new
    @other_income = OtherIncome.new

    @company = Company.find(1)


    @employees = @company.get_employees() 

     @other_income[:importe] = 0.00

  end

  # GET /other_incomes/1/edit
  def edit

     @company = Company.find(1)


    @employees = @company.get_employees() 

  end

  # POST /other_incomes
  # POST /other_incomes.json
  def create
    @other_income = OtherIncome.new(other_income_params)

    respond_to do |format|
      if @other_income.save
        format.html { redirect_to @other_income, notice: 'Other income was successfully created.' }
        format.json { render :show, status: :created, location: @other_income }
      else
        format.html { render :new }
        format.json { render json: @other_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /other_incomes/1
  # PATCH/PUT /other_incomes/1.json
  def update
     @company = Company.find(1)


    @employees = @company.get_employees() 


    respond_to do |format|
      if @other_income.update(other_income_params)
        format.html { redirect_to @other_income, notice: 'Other income was successfully updated.' }
        format.json { render :show, status: :ok, location: @other_income }
      else
        format.html { render :edit }
        format.json { render json: @other_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /other_incomes/1
  # DELETE /other_incomes/1.json
  def destroy
    @other_income.destroy
    respond_to do |format|
      format.html { redirect_to other_incomes_url, notice: 'Other income was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_other_income
      @other_income = OtherIncome.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def other_income_params
      params.require(:other_income).permit(:code, :name, :importe, :documento, :employee_id, :turno,:fecha )
    end
end
