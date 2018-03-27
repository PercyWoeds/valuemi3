class CreateVentaislas < ActiveRecord::Migration
  def change
    create_table :ventaislas do |t|
      t.datetime :fecha
      t.string :turno
      t.integer :employee_id
      t.integer :pump_id
      t.float :importe
      t.float :le_an_gln
      t.float :le_ac_gln
      t.float :galones
      t.float :precio_ven

      t.timestamps null: false
    end
  end
end
