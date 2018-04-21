class CreateTurnos < ActiveRecord::Migration
  def change
    create_table :turnos do |t|
      t.datetime :Fecha
      t.string :turno

      t.timestamps null: false
    end
  end
end
