class CreateRedentionDetails < ActiveRecord::Migration
  def change
    create_table :redention_details do |t|
      t.integer :factura_id
      t.integer :product_id
      t.float :price
      t.float :quantity
      t.float :total
      t.float :discount

      t.timestamps null: false
    end
  end
end
