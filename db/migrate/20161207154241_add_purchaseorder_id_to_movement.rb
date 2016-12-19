class AddPurchaseorderIdToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :purchaseorder, :string
  end
end
