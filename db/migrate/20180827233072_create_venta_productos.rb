class CreateVentaProductos < ActiveRecord::Migration
  def change
    create_table :venta_productos do |t|
      t.datetime :fecha
      t.integer :document_id
      t.string :documento
      t.integer :division_id
      t.float :total_efe
      t.integer :tarjeta_id
      t.float :total_tar

      t.timestamps null: false
    end
  end
end
