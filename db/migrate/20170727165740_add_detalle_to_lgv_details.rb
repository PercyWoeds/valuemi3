class AddDetalleToLgvDetails < ActiveRecord::Migration
  def change
    add_column :lgv_details, :detalle, :string
  end
end
