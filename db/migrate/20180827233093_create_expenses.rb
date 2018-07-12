class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :code
      t.integer :gasto_id
      t.string :documento
      t.text :descrip
      t.float :importe
      t.datetime :fecha
      t.integer :document_id

      t.timestamps null: false
    end
  end
end
