class AddStockFinalToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :stock_final, :integer
  end
end
