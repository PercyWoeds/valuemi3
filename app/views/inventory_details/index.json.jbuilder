json.array!(@inventory_details) do |inventory_detail|
  json.extract! inventory_detail, :id, :product_id, :cost, :logical, :phisycal, :comments
  json.url inventory_detail_url(inventory_detail, format: :json)
end
