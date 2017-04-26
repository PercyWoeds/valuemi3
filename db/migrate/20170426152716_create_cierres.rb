class CreateCierres < ActiveRecord::Migration
  def change
    create_table :cierres do |t|
      t.integer :modulo
      t.string :descrip
      t.datetime :fecha
      t.integer :user_id
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
