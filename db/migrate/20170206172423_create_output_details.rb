class CreateOutputDetails < ActiveRecord::Migration
  def change
    create_table :output_details do |t|
      t.integer :output_id
      t.integer :product_id
      t.float :price
      t.integer :quantity
      t.float :total

      t.timestamps null: false
    end
  end
end
