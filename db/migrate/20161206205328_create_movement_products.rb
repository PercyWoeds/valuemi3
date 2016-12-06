class CreateMovementProducts < ActiveRecord::Migration
  def change
    create_table :movement_products do |t|
      t.integer :movement_id
      t.integer :product_id
      t.integer :unidad_id
      t.float :price
      t.integer :quantity
      t.float :discount
      t.float :total

      t.timestamps null: false
    end
  end
end
