class AddBalanceToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :balance, :float
  end
end
