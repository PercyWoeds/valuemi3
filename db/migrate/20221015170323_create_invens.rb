class CreateInvens < ActiveRecord::Migration
  def change
    create_table :invens do |t|
      t.string :order_id_a
      t.datetime :fecha_a 
      t.string   :concepto 
      t.float :importe
      t.string :estado_a
      t.string :cod_emp_a
      t.datetime :dia_a
      t.string :order_id_b
      t.datetime :fecha_b
      t.string :cod_prod
      t.string :cod_dep
      t.float :stk_act
      t.float :stk_fisico
      t.float :costo 
      t.string :observa 
      t.string :cod_emp_b
      t.string :turno
      t.datetime :dia_b
      t.string :tm
      t.string :estado_b
      t.float :precio
      t.string :name2

      t.timestamps null: false
    end
  end
end
