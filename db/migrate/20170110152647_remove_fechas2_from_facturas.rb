class RemoveFechas2FromFacturas < ActiveRecord::Migration
  def change
    remove_column :facturas, :fechas2, :datetime
  end
end
