class AddMonedaToServiceorders < ActiveRecord::Migration
  def change
    add_column :serviceorders, :moneda, :string
  end
end
