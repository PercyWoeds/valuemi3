class AddTmToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :tm, :string
  end
end
