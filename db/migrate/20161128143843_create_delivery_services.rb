class CreateDeliveryServices < ActiveRecord::Migration
  def change
    create_table :delivery_services do |t|
      t.integer :service_id
      t.integer :price
      t.integer :quantity
      t.integer :unidad_id
      t.integer :peso
      t.float :discount
      t.float :total
      t.integer :delivery_id

      t.timestamps null: false
    end
  end
end
