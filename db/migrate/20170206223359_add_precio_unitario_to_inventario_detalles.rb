class AddPrecioUnitarioToInventarioDetalles < ActiveRecord::Migration
  def change
    add_column :inventario_detalles, :precio_unitario, :float
  end
end
