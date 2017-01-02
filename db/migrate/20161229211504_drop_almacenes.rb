class DropAlmacenes < ActiveRecord::Migration
  def change
  	drop_table :almacenes 
  end
end
