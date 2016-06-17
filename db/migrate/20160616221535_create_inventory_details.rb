class CreateInventoryDetails < ActiveRecord::Migration
  def change
    create_table :inventory_details do |t|
      t.integer :product_id
      t.float :cost
      t.integer :logical
      t.integer :phisycal
      t.text :comments

      t.timestamps null: false
    end
  end
end
