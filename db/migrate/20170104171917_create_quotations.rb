class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.datetime :fecha1
      t.string :code
      t.integer :customer_id
      t.integer :punto_id
      t.text :carga
      t.text :tipo_unidad
      t.float :importe
      t.text :condiciones
      t.text :respon
      t.text :seguro
      t.integer :firma_id
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id

      t.timestamps null: false
    end
  end
end
