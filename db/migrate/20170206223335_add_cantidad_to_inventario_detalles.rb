class AddCantidadToInventarioDetalles < ActiveRecord::Migration
  def change
    add_column :inventario_detalles, :cantidad, :float
  end
end
