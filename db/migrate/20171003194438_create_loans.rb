class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :payroll_id
      t.string :descrip

      t.timestamps null: false
    end
  end
end
