class CreateVenta < ActiveRecord::Migration
  def change
    create_table :venta do |t|
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
      t.float :cantidad
      t.string :precio
      t.string :importe
      t.float :igv
      t.float :fpago
      t.float :dolat
      t.float :implista
      t.string :cod_tar
      t.string :km
      t.string :chofer
      t.string :tk_devol
      t.string :cod_sucu
      t.string :isla
      t.string :dni_cli
      t.string :company_id

      t.timestamps null: false
    end
  end
end
