class CreateTarjeta < ActiveRecord::Migration
  def change
    create_table :tarjeta do |t|
      t.string :code
      t.string :nombre

      t.timestamps null: false
    end
  end
end
