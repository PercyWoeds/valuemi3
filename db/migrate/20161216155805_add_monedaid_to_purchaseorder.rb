class AddMonedaidToPurchaseorder < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :moneda_id, :integer
  end
end
