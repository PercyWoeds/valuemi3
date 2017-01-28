class AddProductIdToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :product_id, :integer
  end
end
