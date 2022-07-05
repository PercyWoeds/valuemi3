class AddTarjetumIdToSellvales < ActiveRecord::Migration
  def change
    add_column :sellvales, :tarjetum_id, :integer
  end
end
