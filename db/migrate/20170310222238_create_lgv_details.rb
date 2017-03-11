class CreateLgvDetails < ActiveRecord::Migration
  def change
    create_table :lgv_details do |t|
      t.datetime :fecha
      t.integer :gasto_id
      t.integer :document_id
      t.string :documento
      t.float :total

      t.timestamps null: false
    end
  end
end
