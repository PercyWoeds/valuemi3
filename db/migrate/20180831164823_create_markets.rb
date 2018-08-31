class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :order_id
      t.string :td
      t.datetime :fecha
      t.string :turno
      t.string :cod_emp
      t.string :caja
      t.string :serie
      t.string :numero
      t.string :cod_cli
      t.string :ruc
      t.string :placa
      t.string :odometro
      t.string :cod_prod
      t.string :cod_prod
      t.float :cantidad
      t.float :precio
      t.float :importe
      t.float :igv
      t.string :fpago
      t.float :dolar
      t.string :cod_dep
      t.string :cod_lin
      t.string :cod_tar
      t.string :dolares
      t.float :precio1
      t.float :margen

      t.timestamps null: false
    end
  end
end
