class DropItems < ActiveRecord::Migration
  
  	 def up
    drop_table :items
 
  end
end
