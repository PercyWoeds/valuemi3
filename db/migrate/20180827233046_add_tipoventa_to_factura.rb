class AddTipoventaToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :tipoventa, :integer
  end
end
