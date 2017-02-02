

json.array!(@bank_acounts) do |bank_acount|
  json.extract! bank_acount, :id, :number,:moneda_id,:bank_id
  json.url employee_url(bank_acount, format: :json)
end
