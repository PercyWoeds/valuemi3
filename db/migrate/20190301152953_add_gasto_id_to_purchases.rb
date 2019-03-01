class AddGastoIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :gasto_id, :integer
  end
end
