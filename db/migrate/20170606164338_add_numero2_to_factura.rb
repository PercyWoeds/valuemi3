class AddNumero2ToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :numero2, :integer
  end
end
