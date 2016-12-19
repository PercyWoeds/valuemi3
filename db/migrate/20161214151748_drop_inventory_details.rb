class DropInventoryDetails < ActiveRecord::Migration
  
  	 def up
    drop_table :inventory_details 
  
  end
end
