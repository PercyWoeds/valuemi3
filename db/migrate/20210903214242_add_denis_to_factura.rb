class AddDenisToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :denis, :string
  end
end
