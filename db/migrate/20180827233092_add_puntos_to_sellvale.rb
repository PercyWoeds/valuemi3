class AddPuntosToSellvale < ActiveRecord::Migration
  def change
    add_column :sellvales, :puntos, :float
  end
end
