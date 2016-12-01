json.array!(@tanks) do |tank|
  json.extract! tank, :id, :comments, :product_id, :company_id
  json.url tank_url(tank, format: :json)
end
