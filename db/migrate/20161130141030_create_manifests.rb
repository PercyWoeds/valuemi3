class CreateManifests < ActiveRecord::Migration
  def change
    create_table :manifests do |t|
      t.integer :customer_id
      t.string :solicitante
      t.datetime :fecha1
      t.string :telefono1
      t.integer :camionetaqty
      t.integer :camionetapeso
      t.integer :camionqty
      t.integer :camionpeso
      t.integer :semiqty
      t.integer :semipeso
      t.integer :extenqty
      t.integer :extenpeso
      t.integer :camaqty
      t.integer :camapeso
      t.integer :modularqty
      t.integer :modularpeso
      t.integer :punto_id
      t.integer :punto2_id
      t.datetime :fecha2
      t.string :contacto1
      t.string :telefono1
      t.string :contacto2
      t.string :telefono2
      t.text :especificacion
      t.float :largo
      t.float :ancho
      t.float :alto
      t.integer :peso
      t.integer :bultos
      t.string :otros
      t.text :observa
      t.text :observa2
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
