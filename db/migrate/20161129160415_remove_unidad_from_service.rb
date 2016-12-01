class RemoveUnidadFromService < ActiveRecord::Migration
  def change
    remove_column :services, :unidad, :string
  end
end
