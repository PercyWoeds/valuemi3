
class Purchases::PurchaseDetailsController < ApplicationController

  
  before_action :set_purchase 
  before_action :set_purchase_detail, :except=> [:new,:create]
  
  
 
  def index
    @purchase_details = PurchaseDetail.all
  end


  def show

  end

  def new
    @purchase_detail = PurchaseDetail.new


  end

  def edit
  	
  

  end

  
  def create
    @purchase_detail = PurchaseDetail.new(purchase_detail_params)
    @purchase_detail.purchase_id  = @purchase.id 
    

    respond_to do |format|
      if @purchase_detail.save
        format.html { redirect_to @purchase , notice: 'Purchase  detail was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def update
    
    @purchase_detail.calcular_saldo 

    respond_to do |format|
      if @purchase_detail.update(purchase_detail_params)
        format.html { redirect_to @purchase, notice: 'Purchase detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @purchase_detail.destroy
    
    respond_to do |format|
      format.html { redirect_to purchase_url, notice: 'Loan detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_purchase 
      @purchase = Purchase.find(params[:purchase_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_detail
      @purchase_detail = PurchaseDetail.find(params[:id])
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_detail_params
      params.require(:purchase_detail).permit(
  	:product_id,:unit_id,:price_with_tax,:price_without_tax,
    :price_public,
    :quantity,
    :totaltax,
    :totaltax2,
    :discount,
    :total,
    :purchase_id,
    :grifo,
    :mayorista,
    :fecha1,
    :qty1,
    :fecha2,
    :qty2,
    :fecha3,
    :qty3,
    :fecha4,
    :qty4,
    :fecha5,
    :qty5,
    :fecha6,
    :qty6,
    :fecha7,
    :qty7,
    :fecha8,
    :qty8,
    :fecha9,
    :qty9,
    :fecha10,
    :qty10)


    end
end


