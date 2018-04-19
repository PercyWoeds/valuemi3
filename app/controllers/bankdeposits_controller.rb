class BankdepositsController < ApplicationController
  before_action :set_bankdeposit, only: [:show, :edit, :update, :destroy]

  # GET /bankdeposits
  # GET /bankdeposits.json
  def index
    @bankdeposits = Bankdeposit.all
  end

  # GET /bankdeposits/1
  # GET /bankdeposits/1.json
  def show
  end

  # GET /bankdeposits/new
  def new
    @bankdeposit = Bankdeposit.new
  end

  # GET /bankdeposits/1/edit
  def edit
  end

  # POST /bankdeposits
  # POST /bankdeposits.json
  def create
    @bankdeposit = Bankdeposit.new(bankdeposit_params)

    respond_to do |format|
      if @bankdeposit.save
        format.html { redirect_to @bankdeposit, notice: 'Bankdeposit was successfully created.' }
        format.json { render :show, status: :created, location: @bankdeposit }
      else
        format.html { render :new }
        format.json { render json: @bankdeposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bankdeposits/1
  # PATCH/PUT /bankdeposits/1.json
  def update
    respond_to do |format|
      if @bankdeposit.update(bankdeposit_params)
        format.html { redirect_to @bankdeposit, notice: 'Bankdeposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @bankdeposit }
      else
        format.html { render :edit }
        format.json { render json: @bankdeposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bankdeposits/1
  # DELETE /bankdeposits/1.json
  def destroy
    @bankdeposit.destroy
    respond_to do |format|
      format.html { redirect_to bankdeposits_url, notice: 'Bankdeposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bankdeposit
      @bankdeposit = Bankdeposit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bankdeposit_params
      params.require(:bankdeposit).permit(:fecha, :code, :bank_account_id, :document_id, :documento, :total)
    end
end
