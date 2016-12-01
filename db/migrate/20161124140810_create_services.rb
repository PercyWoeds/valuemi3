class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :code
      t.string :name
      t.float :cost
      t.float :price
      t.string :tax1_name
      t.float :tax1
      t.integer :quantity
      t.text :description
      t.text :comments
      t.integer :company_id
      t.float :discount
      t.float :currtotal

      t.timestamps null: false
    end
  end
end
