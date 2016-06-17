class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :category_id
      t.float :tot_logical
      t.float :tot_physical
      t.text :comments

      t.timestamps null: false
    end
  end
end
