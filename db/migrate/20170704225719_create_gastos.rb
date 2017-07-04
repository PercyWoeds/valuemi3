class CreateGastos < ActiveRecord::Migration
  def change
    create_table :gastos do |t|
      t.integer :codigo
      t.string :code
      t.string :descrip
      t.string :cuenta

      t.timestamps null: false
    end
  end
end
