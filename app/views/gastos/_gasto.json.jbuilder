json.extract! gasto, :id, :codigo, :code, :descrip, :cuenta, :created_at, :updated_at
json.url gasto_url(gasto, format: :json)