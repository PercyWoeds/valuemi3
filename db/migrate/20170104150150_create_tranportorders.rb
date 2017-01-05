class CreateTranportorders < ActiveRecord::Migration
  def change
    create_table :tranportorders do |t|
      t.string :code
      t.integer :employee_id
      t.integer :truck_id
      t.integer :employee2_id
      t.integer :truck2_id
      t.integer :ubication_id
      t.integer :ubication2_id
      t.datetime :fecha1
      t.datetime :fecha2
      t.text :description
      t.text :comments
      t.string :processed
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id

      t.timestamps null: false
    end
  end
end
