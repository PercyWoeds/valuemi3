class AddDate1ToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :date1, :datetime
  end
end
