class RemoveProductidFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :product_id, :integer
  end
end
