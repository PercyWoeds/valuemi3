class AddMonedaIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :moneda_id, :integer
  end
end
