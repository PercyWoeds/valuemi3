class AddPurchaseorderidToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :purchaseorder_id, :integer
  end
end
