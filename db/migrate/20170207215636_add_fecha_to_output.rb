class AddFechaToOutput < ActiveRecord::Migration
  def change
    add_column :outputs, :fecha, :datetime
  end
end
