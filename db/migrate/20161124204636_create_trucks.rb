class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :code
      t.string :placa
      t.string :clase
      t.integer :marca_id
      t.integer :modelo_id
      t.string :certificado
      t.integer :ejes
      t.string :licencia
      t.string :neumatico
      t.string :config
      t.string :carroceria
      t.integer :anio
      t.string :estado
      t.string :propio

      t.timestamps null: false
    end
  end
end
