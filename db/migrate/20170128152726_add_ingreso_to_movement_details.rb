class AddIngresoToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :ingreso, :integer
  end
end
