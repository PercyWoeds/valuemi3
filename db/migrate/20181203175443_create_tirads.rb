class CreateTirads < ActiveRecord::Migration
  def change
    create_table :tirads do |t|
      t.integer :employee_id
      t.integer :turno
      t.datetime :fecha
      t.float :importe

      t.timestamps null: false
    end
  end
end
