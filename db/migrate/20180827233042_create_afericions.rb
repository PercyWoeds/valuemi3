class CreateAfericions < ActiveRecord::Migration
  def change
    create_table :afericions do |t|
      t.datetime :fecha
      t.string :turno
      t.integer :employee_id
      t.integer :tanque_id
      t.string :documento
      t.float :quantity
      t.float :importe
      t.string :concepto

      t.timestamps null: false
    end
  end
end
