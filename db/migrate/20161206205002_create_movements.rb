class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :supplier_id
      t.text :description
      t.text :comments
      t.datetime :fecha1
      t.datetime :fecha2
      t.integer :payment_id
      t.string :money
      t.string :code
      t.float :subtotal
      t.float :tax
      t.float :detraccion
      t.float :percepcion
      t.float :total
      t.string :processed
      t.string :return
      t.datetime :date_proceseed
      t.integer :user_id
      t.string :tm

      t.timestamps null: false
    end
  end
end
