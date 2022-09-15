class CreateOtherIncomes < ActiveRecord::Migration
  def change
    create_table :other_incomes do |t|
      t.string :code
      t.string :name
      t.float :importe
      t.text :documento
      t.integer :employee_id
      t.string :turno

      t.timestamps null: false
    end
  end
end
