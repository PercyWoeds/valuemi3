class AddPurchaseIdToServiceorders < ActiveRecord::Migration
  def change
    add_column :serviceorders, :purchase_id, :integer
  end
end
