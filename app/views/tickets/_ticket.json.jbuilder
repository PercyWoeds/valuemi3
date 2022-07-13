json.extract! ticket, :id, :code, :fecha, :cantidad, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
