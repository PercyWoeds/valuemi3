class AddSalidaToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :salida, :integer
  end
end
