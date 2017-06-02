class AjustDetail < ActiveRecord::Base

  validates_presence_of :ajust_id, :product_id, :quantity
  
  belongs_to :ajust 
  belongs_to :product

  private
  
  def ajust_detail_params
    params.require(:ajust_detail).permit(:product_id,:quantity)
  end


end


