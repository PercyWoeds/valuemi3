class AddTipoventaIdToTipoventa < ActiveRecord::Migration
  def change
    add_column :tipoventa, :tipoventa_id, :integer
  end
end
