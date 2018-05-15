json.extract! venta_producto, :id, :fecha, :document_id, :documento, :division_id, :total_efe, :tarjeta_id, :total_tar, :created_at, :updated_at
json.url venta_producto_url(venta_producto, format: :json)
