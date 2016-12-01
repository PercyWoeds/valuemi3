class CreatePuntos < ActiveRecord::Migration
  def change
    create_table :puntos do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
