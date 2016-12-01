json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :company_id, :location_id, :division, :description, :comments, :category_id, :logicalStock, :physicalStock, :cost, :total, :processed, :date_processed, :user_id
  json.url inventory_url(inventory, format: :json)
end
