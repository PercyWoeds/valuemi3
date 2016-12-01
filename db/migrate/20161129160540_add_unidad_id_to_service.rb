class AddUnidadIdToService < ActiveRecord::Migration
  def change
    add_column :services, :unidad_id, :integer
  end
end
