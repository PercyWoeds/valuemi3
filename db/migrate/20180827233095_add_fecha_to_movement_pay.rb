class AddFechaToMovementPay < ActiveRecord::Migration
  def change
    add_column :movement_pays, :fecha, :datetime
  end
end
