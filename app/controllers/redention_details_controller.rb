class RedentionDetailsController < ApplicationController
	
    before_action :set_redention, only: [:new, :create, :destroy]	

	def new
		@redention_details = @redention.redention_details.build
		@redention_details.product = Item.first
	end

	def create
		item_exists = false
		item_id = params[:redention_details][:product_id].to_i
		@redention.redention_details.each do |detail|
			if detail.item_id == item_id
				# Ya existe el item en la factura, agregar cantidad
				item_exists = true
				@redention_detail = detail
				@saved_redention_detail = detail.id
				break
			end
		end
		if item_exists
			@redention_detail.quantity += params[:redention_details][:quantity].to_i
			@redention_detail.price = params[:redention_details][:price].to_f
			@redention_detail.save!
		else
			redention_detail = redentionDetail.new(redention_details_params)
			if @redention.redention_details.last.nil?
				redention_detail.number = 1
			else
				redention_detail.number = @redention.redention_details.last.number + 1
			end
			@redention.redention_details << redention_detail
		end
		@redention.save!
	end

	def edit
		@redention_detail = redentionDetail.find(params[:id])
	end

	def update
	end

	def destroy
		@redention_detail = redentionDetail.find(params[:id])
		@redention_detail.destroy

		respond_to do |format|
			format.js { render layout: false }
		end
	end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redention
      @redention = Redention.find(params[:redention_id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redention_details_params
      params.require(:redention_details).permit(:id, :redention_id, :item_id, :item_description, :number, :quantity, :price, :_destroy)
    end
end



