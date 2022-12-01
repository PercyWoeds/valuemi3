class CreatePlanners < ActiveRecord::Migration
  def change
    create_table :planners do |t|
      t.integer :employee_id
      t.integer :tipomov_id
      t.float :importe
      t.string :documento
      t.text :observa

      t.timestamps null: false
    end
  end
end
