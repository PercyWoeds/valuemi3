class CreateLgvs < ActiveRecord::Migration
  def change
    create_table :lgvs do |t|
      t.string :code
      t.integer :tranportorderd_id
      t.datetime :fecha
      t.integer :viatico_id
      t.float :total
      t.string :devuelto_texto
      t.float :devuelto
      t.float :reembolso
      t.float :descuento
      t.text :observa

      t.timestamps null: false
    end
  end
end
