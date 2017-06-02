class CreateAjustDetails < ActiveRecord::Migration
  def change
    create_table :ajust_details do |t|
      t.integer :ajust_id
      t.integer :product_id
      t.float :quantity
      t.float :quantity_transit

      t.timestamps null: false
    end
  end
end
