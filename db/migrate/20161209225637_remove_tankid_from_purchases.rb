class RemoveTankidFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :tank_id, :integer
  end
end
