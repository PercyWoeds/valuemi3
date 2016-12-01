json.array!(@employees) do |employee|
  json.extract! employee, :id, :firstname, :lastname, :address1, :address2, :city, :state, :zip, :country, :phone1, :phone2, :email1, :email2, :company_id
  json.url employee_url(employee, format: :json)
end
