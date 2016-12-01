class CreateFacturas < ActiveRecord::Migration
  def change
    create_table :facturas do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :customer_id
      t.text :description
      t.text :comments
      t.string :code
      t.float :subtotal
      t.float :tax
      t.float :total
      t.string :processed
      t.string :return
      t.datetime :date_processed
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
