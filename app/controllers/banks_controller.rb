class BanksController < ApplicationController

def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path ="guia"
    @pagetitle = "banks"
    @banks = Bank.all 

  end

  # GET /deliverys/1
  # GET /deliverys/1.xml
  def show
    @bank  = Bank.find(params[:id])
  end

  # GET /deliverys/new
  # GET /deliverys/new.xml
  
  def new
    @bank  = Bank.new
  end

  # GET /deliverys/1/edit
  def edit
        @bank  = Bank.find(params[:id])
  end

  # POST /deliverys
  # POST /deliverys.xml
  def create
    @bank = Bank.new(bank_params)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Tank was successfully created.' }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PUT /deliverys/1
  # PUT /deliverys/1.xml
  def update
     respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice: 'Tank was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverys/1,a
  # DELETE /deliverys/1.xml
  def destroy
       @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url, notice: 'Bank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @Bank = Bank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(:name , :address1,:address2,:phone1,:email ) 
    end


end
