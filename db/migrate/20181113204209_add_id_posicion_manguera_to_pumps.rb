class AddIdPosicionMangueraToPumps < ActiveRecord::Migration
  def change
    add_column :pumps, :id_posicion_manguera, :integer
  end
end
