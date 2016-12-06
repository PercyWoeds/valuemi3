class CreatePurchaseorderDetails < ActiveRecord::Migration
  def change
    create_table :purchaseorder_details do |t|
      t.integer :purchaseorder_id
      t.integer :product_id
      t.integer :unidad_id
      t.float   :price
      t.integer :quantity
      t.float   :discount
      t.float   :total

      t.timestamps null: false
    end
  end
end
