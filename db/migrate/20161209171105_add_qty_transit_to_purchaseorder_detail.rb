class AddQtyTransitToPurchaseorderDetail < ActiveRecord::Migration
  def change
    add_column :purchaseorder_details, :quantity_transit, :integer
  end
end
