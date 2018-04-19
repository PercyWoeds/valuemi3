json.extract! bankdeposit, :id, :fecha, :code, :bank_account_id, :document_id, :documento, :total, :created_at, :updated_at
json.url bankdeposit_url(bankdeposit, format: :json)
