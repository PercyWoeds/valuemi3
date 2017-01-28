class AddFechaToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :fecha, :datetime
  end
end
