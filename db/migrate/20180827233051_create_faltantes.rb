class CreateFaltantes < ActiveRecord::Migration
  def change
    create_table :faltantes do |t|
      t.integer :employee_id
      t.integer :tipofaltante_id
      t.string :descrip
      t.text :comments

      t.timestamps null: false
    end
  end
end
