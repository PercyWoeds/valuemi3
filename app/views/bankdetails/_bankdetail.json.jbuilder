json.extract! bankdetail, :id, :bank_acount_id, :fecha, :saldo_inicial, :total_abono, :total_cargo, :created_at, :updated_at
json.url bankdetail_url(bankdetail, format: :json)
