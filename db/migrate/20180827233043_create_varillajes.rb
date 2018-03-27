class CreateVarillajes < ActiveRecord::Migration
  def change
    create_table :varillajes do |t|
      t.integer :tanque_id
      t.integer :product_id
      t.float :inicial
      t.float :compras
      t.float :directo
      t.float :consumo
      t.float :transfe
      t.float :saldo
      t.float :varilla
      t.string :dife_dia
      t.datetime :fecha
      t.string :documento

      t.timestamps null: false
    end
  end
end
