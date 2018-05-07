class FacturaDetailsController < ApplicationController
    
  before_action :set_factura
  
  before_action :set_factura_detail, :except=> [:new,:create]

  
    
    
def destroy
    @payroll_detail.destroy
    respond_to do |format|
      format.html { redirect_to factura_details_url, notice: 'Detalle factura fue eliminad con exito !!.' }
      format.json { head :no_content }
    end
  end

  private
  
   
    # Use callbacks to share common setup or constraints between actions.
    def set_factura 
      @factura = Factura.find(params[:factura_id])
    end

    def set_factura_detail
      
      @factura_detail =FacturaDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def factura_detail_params
      params.require(:factura_detail).permit(:id, :factura_id, :sellvale_id, :producto_id, :price, :price_discount, :quantity, :total,:product_id, :discount)
    end

end
