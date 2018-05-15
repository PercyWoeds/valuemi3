class AddCodeToVentaProductos < ActiveRecord::Migration
  def change
    add_column :venta_productos, :code, :string
  end
end
