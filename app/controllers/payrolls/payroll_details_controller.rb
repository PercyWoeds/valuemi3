class Payrolls::PayrollDetailsController < ApplicationController
  
  before_action :set_payroll
  
  before_action :set_payroll_detail, :except=> [:new,:create]

  
  # GET /payroll_details
  # GET /payroll_details.json
  def index
    @payroll_details = PayrollDetail.all
  end

  # GET /payroll_details/1
  # GET /payroll_details/1.json
  def show
  end

  # GET /payroll_details/new
  def new
    @payroll_detail = PayrollDetail.new
  end

  # GET /payroll_details/1/edit
  def edit
  end

  # POST /payroll_details
  # POST /payroll_details.json
  def create
    @payroll_detail = PayrollDetail.new(payroll_detail_params)

    respond_to do |format|
      if @payroll_detail.save
        format.html { redirect_to @payroll, notice: 'Payroll detail was successfully created.' }
        format.json { render :show, status: :created, location: @payroll }
      else
        format.html { render :new }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payroll_details/1
  # PATCH/PUT /payroll_details/1.json
  def update
    respond_to do |format|
      if @payroll_detail.update(payroll_detail_params)
        format.html { redirect_to @payroll, notice: 'Payroll detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_details/1
  # DELETE /payroll_details/1.json
  def destroy
    @payroll_detail.destroy
    respond_to do |format|
      format.html { redirect_to payroll_details_url, notice: 'Payroll detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:payroll_id])
    end

    def set_payroll_detail
      @payroll_detail = PayrollDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_detail_params
      params.require(:payroll_detail).permit(:employee_id, :remuneracion, :calc1, :calc2, :calc3, :total1, :calc4, :calc5, :calc6, :calc7, :total2, :remneta, :calc8, :calc9, :calc10, :total3)
    end
end
