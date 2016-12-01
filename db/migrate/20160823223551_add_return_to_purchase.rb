class AddReturnToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :return, :string
  end
end
