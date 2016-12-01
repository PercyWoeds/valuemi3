class CreatePurchaseDetails < ActiveRecord::Migration
  def change
    create_table :purchase_details do |t|
      t.integer :product_id
      t.integer :unit_id
      t.float :price_with_tax
      t.float :price_without_tax
      t.float :price_public
      t.float :quantity

      t.timestamps null: false
    end
  end
end
