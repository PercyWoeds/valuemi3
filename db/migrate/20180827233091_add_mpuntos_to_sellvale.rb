class AddMpuntosToSellvale < ActiveRecord::Migration
  def change
    add_column :sellvales, :mpuntos, :float
  end
end
