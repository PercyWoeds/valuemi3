class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.text :description
      t.text :comments
      t.integer :category_id
      t.float :logicalStock
      t.float :physicalStock
      t.float :cost
      t.float :total
      t.string :processed
      t.datetime :date_processed
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
