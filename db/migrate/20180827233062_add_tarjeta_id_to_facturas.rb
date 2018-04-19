class AddTarjetaIdToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :tarjeta_id, :integer
  end
end
