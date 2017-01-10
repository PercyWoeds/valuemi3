class AddFecha2ToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :fechas2, :datetime
  end
end
