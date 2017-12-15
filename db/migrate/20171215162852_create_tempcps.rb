class CreateTempcps < ActiveRecord::Migration
  def change
    create_table :tempcps do |t|
      t.datetime :fecha2
      t.string :month_year
      t.integer :customer_id
      t.float :balance
      t.integer :moneda_id

      t.timestamps null: false
    end
  end
end
