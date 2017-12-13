class BankdetailsController < ApplicationController
  before_action :set_bankdetail, only: [:show, :edit, :update, :destroy]

  # GET /bankdetails
  # GET /bankdetails.json
  def index
    @bankdetails = Bankdetail.all
  end

  # GET /bankdetails/1
  # GET /bankdetails/1.json
  def show
    @bancos =BankAcount.all 
   @company = Company.find(1)
   
  end

  # GET /bankdetails/new
  def new
    @bankdetail = Bankdetail.new
    
    @company = Company.find(1)
    
    @bankdetail.company_id = @company.id
    
    @bancos =BankAcount.all 
    @bankdetail.fecha = Date.today()
    @bankdetail.saldo_inicial = 0.0
    @bankdetail.total_abono = 0.0
    @bankdetail.total_cargo = 0.0
    @bankdetail.saldo_final = 0.0
    
  end

  # GET /bankdetails/1/edit
  def edit
  end

  # POST /bankdetails
  # POST /bankdetails.json
  def create
    @bankdetail = Bankdetail.new(bankdetail_params)
    @bancos = BankAcount.all 
    @company = Company.find(1)
    @bankdetail.company_id= @company.id  
    respond_to do |format|
      if @bankdetail.save
        format.html { redirect_to @bankdetail, notice: 'Bankdetail was successfully created.' }
        format.json { render :show, status: :created, location: @bankdetail }
      else
        format.html { render :new }
        format.json { render json: @bankdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bankdetails/1
  # PATCH/PUT /bankdetails/1.json
  def update
    respond_to do |format|
      if @bankdetail.update(bankdetail_params)
        format.html { redirect_to @bankdetail, notice: 'Bankdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @bankdetail }
      else
        format.html { render :edit }
        format.json { render json: @bankdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bankdetails/1
  # DELETE /bankdetails/1.json
  def destroy
    @bankdetail.destroy
    respond_to do |format|
      format.html { redirect_to bankdetails_url, notice: 'Bankdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bankdetail
      @bankdetail = Bankdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bankdetail_params
      params.require(:bankdetail).permit(:bank_acount_id, :fecha, :saldo_inicial, :total_abono, :total_cargo,:saldo_final)
    end
end
