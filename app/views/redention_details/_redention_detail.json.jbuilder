json.extract! redention_detail, :id, :factura_id, :product_id, :price, :quantity, :total, :discount, :created_at, :updated_at
json.url redention_detail_url(redention_detail, format: :json)
