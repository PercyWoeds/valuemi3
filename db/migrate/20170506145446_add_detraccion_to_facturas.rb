class AddDetraccionToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :detraccion, :float
  end
end
