class AddToToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :to, :string
  end
end
