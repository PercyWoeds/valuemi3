class AddCajaIdToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :caja_id, :integer
  end
end
