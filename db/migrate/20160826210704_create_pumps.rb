class CreatePumps < ActiveRecord::Migration
  def change
    create_table :pumps do |t|
      t.string :fuel
      t.string :pump01
      t.integer :tank_id
      t.integer :product_id
      t.float :price_buy
      t.float :price_sell
      t.float :le_an_gln
      t.float :le_ac_gln
      t.float :gln
      t.datetime :date1
      t.integer :employee_id
      t.string :turno

      t.timestamps null: false
    end
  end
end
