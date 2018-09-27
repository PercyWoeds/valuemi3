class AddIscToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :isc, :float
  end
end
