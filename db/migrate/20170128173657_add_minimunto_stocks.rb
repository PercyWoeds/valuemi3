class AddMinimuntoStocks < ActiveRecord::Migration
  def change
  	add_column :stocks, :minimum, :float
  end
end
