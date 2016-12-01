class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.integer :company_id
      t.integer :location_id
      t.string :division_id_integer
      t.integer :customer_id
      t.text :description
      t.text :comments
      t.string :code
      t.float :subtotal
      t.float :tax
      t.float :total
      t.string :processes
      t.string :return
      t.datetime :date_processes
      t.integer :user_id
      t.datetime :fecha1
      t.datetime :fecha2
      t.integer :employee_id
      t.integer :empsub_id
      t.integer :subcontrat_id
      t.integer :truck_id
      t.integer :truck2_id
      t.integer :address_id
      t.integer :remision

      t.timestamps null: false
    end
  end
end
