class ProductsSugestionController < ApplicationController
    def index
		if params[:query].present?
			query = params[:query]
			condition1 = "unaccent(lower(products.name)) LIKE '%#{I18n.transliterate(query.downcase)}%'"
			
			@items = Product.where(condition1)
			@items.each do |item|
				item.name = item.item_description
			end
		end
		@items ||= Product.none

		render json: @items
	end
end
