class AddFechas2ToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :fecha2, :datetime
  end
end
