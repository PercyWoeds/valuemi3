class CreateAlmacens < ActiveRecord::Migration
  def change
    create_table :almacens do |t|
      t.string :nombre
      t.string :direccion
      t.string :codigo
      t.string :telefono

      t.timestamps null: false
    end
  end
end
