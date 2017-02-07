class AddProductIdToInventarioDetalles < ActiveRecord::Migration
  def change
    add_column :inventario_detalles, :product_id, :integer
  end
end
