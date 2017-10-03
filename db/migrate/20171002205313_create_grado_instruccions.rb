class CreateGradoInstruccions < ActiveRecord::Migration
  def change
    create_table :grado_instruccions do |t|
      t.integer :code
      t.string :name

      t.timestamps null: false
    end
  end
end
