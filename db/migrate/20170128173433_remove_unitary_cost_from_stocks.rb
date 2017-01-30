class RemoveUnitaryCostFromStocks < ActiveRecord::Migration
  def change
    remove_column :stocks, :unitary_cost, :decimal
  end
end
