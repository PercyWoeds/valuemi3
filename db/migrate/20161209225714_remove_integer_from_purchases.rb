class RemoveIntegerFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :integer, :integer
  end
end
