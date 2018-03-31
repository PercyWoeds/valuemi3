class AddTipoventaIdToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :tipoventa_id, :integer
  end
end
