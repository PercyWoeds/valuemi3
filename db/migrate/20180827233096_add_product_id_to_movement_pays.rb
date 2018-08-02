class AddProductIdToMovementPays < ActiveRecord::Migration
  def change
    add_column :movement_pays, :product_id, :integer
  end
end
