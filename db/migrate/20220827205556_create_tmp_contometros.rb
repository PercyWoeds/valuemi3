class CreateTmpContometros < ActiveRecord::Migration
  def change
    create_table :tmp_contometros do |t|
      t.integer :nid_cierreturno
      t.integer :nid_surtidor
      t.integer :nid_mangueras
      t.integer :nid_producto
      t.integer :nid_tanque
      t.float :dprecio_producto
      t.float :dcontometroinicial_manguera
      t.float :dcontometroactual_manguera
      t.float :dtotgalvendido_manguera
      t.float :dimporte
      t.float :dnocontabilizado_manguera
      t.float :dstockactual
      t.datetime :ffechaproceso_cierreturno

      t.timestamps null: false
    end
  end
end
