class AddMoneyToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :money, :string
  end
end
