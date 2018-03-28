class BankAcountsController < ApplicationController

	def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path ="bank"
    @pagetitle = "bankAcounts"
    @bank_acounts = BankAcount.all 
  end

  # GET /deliverys/1
  # GET /deliverys/1.xml
  def show
    @bank_acount  = BankAcount.find(params[:id])    
    @monedas = @bank_acount.get_monedas
    @bancos  = @bank_acount.get_bancos

  end

  # GET /deliverys/new
  # GET /deliverys/new.xml
  
  def new
    @bank_acount = BankAcount.new
    @monedas= Moneda.all 
    @bancos = Bank.all 
  end

  # GET /deliverys/1/edit
  def edit
    @bank_acount  = BankAcount.find(params[:id])      
    
    @monedas = @bank_acount.get_monedas
    @bancos  = @bank_acount.get_bancos

  end

  # POST /deliverys
  # POST /deliverys.xml
  def create
    @bank_acount = BankAcount.new(bank_acount_params)

    respond_to do |format|
      if @bank_acount.save
        format.html { redirect_to @bank_acount, notice: 'Tank was successfully created.' }
        format.json { render :show, status: :created, location: @bank_acount }
      else
        format.html { render :new }
        format.json { render json: @bank_acount.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PUT /deliverys/1
  # PUT /deliverys/1.xml
  def update
    @bank_acount  = BankAcount.find(params[:id])      
    @monedas = @bank_acount.get_monedas
    @bancos  = @bank_acount.get_bancos

    respond_to do |format|
      if @bank_acount.update(bank_acount_params)
        format.html { redirect_to @bank_acount, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank_acount }
      else
        format.html { render :edit }
        format.json { render json: @bank_acount.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /deliverys/1,a
  # DELETE /deliverys/1.xml
  def destroy
    @bank_acount= BankAcount.find(params[:id])
    company_id = @bank_acount[:company_id]

    @bank_acount.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/bank_acounts/" + company_id.to_s) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_acount
      @bank_acount = BankAcount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_acount_params
      params.require(:bank_acount).permit(:number , :moneda_id,:bank_id ,:cuenta ) 
    end
end
