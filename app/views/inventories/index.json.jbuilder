json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :category_id, :tot_logical, :tot_physical, :comments
  json.url inventory_url(inventory, format: :json)
end
