class CreateLoanDetails < ActiveRecord::Migration
  def change
    create_table :loan_details do |t|
      t.integer :employee_id
      t.integer :valor_id
      t.string :tm
      t.text :detalle

      t.timestamps null: false
    end
  end
end
