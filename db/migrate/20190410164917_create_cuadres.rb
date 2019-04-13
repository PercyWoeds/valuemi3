class CreateCuadres < ActiveRecord::Migration
  def change
    create_table :cuadres do |t|
      t.datetime  :fecha
      t.float :venta
      t.float :cash
      t.float :tcredit
      t.float :credit
      t.float :serafin
      t.float :remito
      t.float :diference
      t.integer :employee_id

      t.timestamps null: false
    end
  end
end
