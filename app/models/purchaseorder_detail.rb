class PurchaseorderDetail < ActiveRecord::Base

	validates_presence_of :purchaseorder_id, :product_id, :price, :quantity, :discount, :total
  
  belongs_to :purchaseorder
  belongs_to :product
  before_save :calcular_transito


  private

  def calcular_transito

		self.quantity_transit  = self.quantity - self.pending
		
  end 


    private
  def purchaseorderdetail_params
    params.require(:purchaseorderdetail).permit(:product_id,:unidad_id,:price,:quantity,:discount,:total,:quantity_transit,:pending)
	  end


end

