class RemoveCantidadFromInventarioDetalles < ActiveRecord::Migration
  def change
    remove_column :inventario_detalles, :cantidad, :decimal
  end
end
