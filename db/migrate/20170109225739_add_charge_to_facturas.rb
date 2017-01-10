class AddChargeToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :charge, :float
  end
end
