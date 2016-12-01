class AddFechaToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :fecha, :datetime
  end
end
