class RemoveCajaIdFromCajas < ActiveRecord::Migration
  def change
    remove_column :cajas, :caja_id, :integer
  end
end
