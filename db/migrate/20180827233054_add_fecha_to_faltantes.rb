class AddFechaToFaltantes < ActiveRecord::Migration
  def change
    add_column :faltantes, :fecha, :datetime
  end
end
