class Facturas::FacturasDetailsController < ApplicationController
    
  before_action :set_factura
  
  before_action :set_factura_detail, :except=> [:new,:create]

  
  def destroy
     if @factura_detail.destroy
    
             a = Sellvale.find(@factura_detail.sellvale_id)
             a.processed ='0'
             a.save
             
            @factura[:total] = @factura.get_subtotal2.round(2)
            lcTotal = @factura[:total]  / 1.18
            @factura[:subtotal] = lcTotal.round(2)
            lcTax =@factura[:total] - @factura[:subtotal]
            @factura[:tax] = lcTax.round(2)
            
            @factura[:balance] = @factura[:total]
            @factura[:pago] = 0
            @factura[:charge] = 0
            @factura[:descuento] = "1"
            
     end       
     
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
      params.require(:factura_detail).permit(:id, :factura_id, :sellvale_id, :producto_id, :price, :price_discount, :quantity, :total,:product_id, :discount,:price3)
    end

end
