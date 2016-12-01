class CreateInventoryDetails < ActiveRecord::Migration
  def change
    create_table :inventory_details do |t|
      t.integer :inventory_id
      t.integer :product_id
      t.float :logicalStock
      t.float :physicalStock
      t.float :cost
      t.float :price
      t.float :totallogical
      t.float :totalphysical

      t.timestamps null: false
    end
  end
end
