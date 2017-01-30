class AddQuantitytoStocks < ActiveRecord::Migration
  def change
  	add_column :stocks, :quantity, :float
  end
end
