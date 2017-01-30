class AddUnitaryCostToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :unitary_cost, :float
  end
end
