class AddAmountToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :amount, :float
  end
end
