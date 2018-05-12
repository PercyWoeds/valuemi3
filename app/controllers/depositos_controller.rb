class DepositosController < ApplicationController
  before_action :set_deposito, only: [:show, :edit, :update, :destroy]

  # GET /depositos
  # GET /depositos.json
  def index
    @depositos = Deposito.all
  end

  # GET /depositos/1
  # GET /depositos/1.json
  def show
  end

  # GET /depositos/new
  def new
    @deposito = Deposito.new
  end

  # GET /depositos/1/edit
  def edit
  end

  # POST /depositos
  # POST /depositos.json
  def create
    @deposito = Deposito.new(deposito_params)

    respond_to do |format|
      if @deposito.save
        format.html { redirect_to @deposito, notice: 'Deposito was successfully created.' }
        format.json { render :show, status: :created, location: @deposito }
      else
        format.html { render :new }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /depositos/1
  # PATCH/PUT /depositos/1.json
  def update
    respond_to do |format|
      if @deposito.update(deposito_params)
        format.html { redirect_to @deposito, notice: 'Deposito was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposito }
      else
        format.html { render :edit }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /depositos/1
  # DELETE /depositos/1.json
  def destroy
    @deposito.destroy
    respond_to do |format|
      format.html { redirect_to depositos_url, notice: 'Deposito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposito
      @deposito = Deposito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deposito_params
      params.require(:deposito).permit(:company_id, :location_id, :division_id, :bank_account_id, :document_id, :documento, :customer_id, :tm, :total, :fecha1, :fecha2, :nrooperacion, :descrip, :comments, :user_id, :processed, :date_processed, :code, :bank_acount_id, :concept_id, :compen)
    end
end
