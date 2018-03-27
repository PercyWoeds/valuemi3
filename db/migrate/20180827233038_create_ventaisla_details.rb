class CreateVentaislaDetails < ActiveRecord::Migration
  def change
    create_table :ventaisla_details do |t|
      t.integer :pump_id
      t.float :le_an_gln
      t.float :le_ac_gln
      t.float :price
      t.float :quantity
      t.float :total

      t.timestamps null: false
    end
  end
end
