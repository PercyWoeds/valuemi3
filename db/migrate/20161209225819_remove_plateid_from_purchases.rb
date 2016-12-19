class RemovePlateidFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :plate_id, :integer
  end
end
