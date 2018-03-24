class AddDescuentoToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :descuento, :string
  end
end
