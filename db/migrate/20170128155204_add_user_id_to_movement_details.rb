class AddUserIdToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :user_id, :integer
  end
end
