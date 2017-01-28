class AddStockInicialToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :stock_inicial, :integer
  end
end
