class CreateDevols < ActiveRecord::Migration
  def change
    create_table :devols do |t|
      t.string :cod_prod
      t.datetime :fecha
      t.string :documento
      t.string :observa

      t.timestamps null: false
    end
  end
end
