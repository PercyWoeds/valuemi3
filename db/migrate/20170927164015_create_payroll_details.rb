class CreatePayrollDetails < ActiveRecord::Migration
  def change
    create_table :payroll_details do |t|
      t.integer :employee_id
      t.float :remuneracion
      t.float :calc1
      t.float :calc2
      t.float :calc3
      t.float :total1
      t.float :calc4
      t.float :calc5
      t.float :calc6
      t.float :calc7
      t.float :total2
      t.float :remneta
      t.float :calc8
      t.float :calc9
      t.float :calc10
      t.float :total3

      t.timestamps null: false
    end
  end
end
