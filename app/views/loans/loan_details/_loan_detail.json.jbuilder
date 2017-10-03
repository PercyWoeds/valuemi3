json.extract! loan_detail, :id, :employee_id, :valor_id, :tm, :detalle, :created_at, :updated_at
json.url loan_detail_url(loan_detail, format: :json)
