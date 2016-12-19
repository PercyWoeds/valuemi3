class DropInventories < ActiveRecord::Migration
 
  def up
    drop_table :inventory

  end
end
