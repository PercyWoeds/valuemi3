class AddPurchaseorderIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :purchaseorder_id, :integer
  end
end
