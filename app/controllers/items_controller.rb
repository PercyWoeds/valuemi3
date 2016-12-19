class ItemsController < ApplicationController

 def update    
 	 @item= PurchaseorderDetail.find(params[:id])
   purchaseorder_id = @item.purchaseorder_id

 	 @item.pending  =params[:item][:pending]
   @item.id       =params[:item][:id]
 	 
   puts @item.pending
   puts @item.id 

    respond_to do |format|
      if @item.update(item_params)     
        format.html { redirect_to("/purchaseorders/receive/" + purchaseorder_id.to_s)}
        format.xml  { head :ok }

      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end        

  end

  def create
      @cart = current_cart
      product = Product.find(params[:product_id])
      @item = @cart.add_product(product.id)

      respond_to do |format|
      if @item.save
        
      format.html { redirect_to store_url }
      format.js { @current_item = @item }
      format.json { render json: @item,
      status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors,
        status: :unprocessable_entity }
      end
   end
  end 


private

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:product_id,:cart,:id,:pending)
    end


end
