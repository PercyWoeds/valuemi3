class AddPendingToPurchaseorderDetails < ActiveRecord::Migration
  def change
    add_column :purchaseorder_details, :pending, :integer
  end
end
