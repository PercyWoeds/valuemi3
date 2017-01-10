class AddMonedaIdToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :moneda_id, :integer
  end
end
