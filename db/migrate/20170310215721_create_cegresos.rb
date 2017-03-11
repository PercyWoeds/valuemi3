class CreateCegresos < ActiveRecord::Migration
  def change
    create_table :cegresos do |t|
      t.integer :employee_id
      t.integer :transportorder_id
      t.datetime :fecha1
      t.datetime :fecha2
      t.text :observa
      t.text :descrip
      t.float :importe
      t.integer :moneda_id

      t.timestamps null: false
    end
  end
end
