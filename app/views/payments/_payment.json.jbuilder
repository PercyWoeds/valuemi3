json.extract! payment, :id, :descrip, :comment, :day, :created_at, :updated_at
json.url payment_url(payment, format: :json)