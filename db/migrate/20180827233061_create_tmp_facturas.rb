class CreateTmpFacturas < ActiveRecord::Migration
  def change
    create_table :tmp_facturas do |t|
      t.datetime :fecha
      t.string :serie
      t.string :numero
      t.float :subtotal
      t.float :tax
      t.float :total
      t.string :ruc

      t.timestamps null: false
    end
  end
end
