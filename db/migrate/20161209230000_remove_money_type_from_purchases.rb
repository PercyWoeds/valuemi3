class RemoveMoneyTypeFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :money_type, :integer
  end
end
