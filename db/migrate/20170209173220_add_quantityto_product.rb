class AddQuantitytoProduct < ActiveRecord::Migration
  def change
  	    add_column :products, :quantity, :float 
  end
end
