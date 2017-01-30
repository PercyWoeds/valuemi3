class RemoveMinimunFromStocks < ActiveRecord::Migration
  def change
    remove_column :stocks, :minimum, :decimal
  end
end
