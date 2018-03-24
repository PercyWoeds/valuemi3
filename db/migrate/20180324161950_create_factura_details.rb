class CreateFacturaDetails < ActiveRecord::Migration
  def change
    create_table :factura_details do |t|
      t.integer :factura_id
      t.integer :sellvale_id
      t.integer :producto_id
      
      t.float :price
      t.float :price_discount
      t.float :quantity
      t.float :total

      t.timestamps null: false
    end
  end
end
