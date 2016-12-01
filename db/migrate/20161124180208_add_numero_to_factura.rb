class AddNumeroToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :numero, :string
  end
end
