class RemovePrecioUnitarioFromInventarioDetalles < ActiveRecord::Migration
  def change
    remove_column :inventario_detalles, :precio_unitario, :decimal
  end
end
