class DropInventories < ActiveRecord::Migration
 
  def up
    drop_table :inventories

  end
end
