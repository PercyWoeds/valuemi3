class AddReceivedToPurchaseorder < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :received, :string
  end
end
