class CreateFiveparameters < ActiveRecord::Migration
  def change
    create_table :fiveparameters do |t|
      t.integer :anio
      t.float :valor_uit
      t.float :hasta_5
      t.float :tasa1
      t.float :exceso_5
      t.float :y_hasta_20
      t.float :exceso_20
      t.float :y_hasta_35
      t.float :exceso_35
      t.float :y_hasta_45
      t.float :exceso_45

      t.timestamps null: false
    end
  end
end
