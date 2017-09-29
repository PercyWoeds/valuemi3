class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.string :code
      t.string :type_payroll
      t.string :integer
      t.datetime :fecha
      t.datetime :fecha_inicial
      t.datetime :fecha_final
      t.datetime :fecha_pago
      t.integer :company_id 
      t.integer :user_id 

      t.timestamps null: false
    end
  end
end
