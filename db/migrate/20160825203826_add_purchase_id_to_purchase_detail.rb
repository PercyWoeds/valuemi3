class AddPurchaseIdToPurchaseDetail < ActiveRecord::Migration
  def change
    add_column :purchase_details, :purchase_id, :integer
  end
end
