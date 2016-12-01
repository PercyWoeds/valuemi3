class CreateDeclarations < ActiveRecord::Migration
  def change
    create_table :declarations do |t|
      t.string :code
      t.integer :employee_id
      t.integer :punto_id
      t.integer :punto2_id
      t.integer :truck_id
      t.integer :truck2_id
      t.datetime :fecha1
      t.datetime :fecha2
      t.text :observacion

      t.timestamps null: false
    end
  end
end
