class AddAsigfamiliarToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :asigfamiliar, :float
  end
end
