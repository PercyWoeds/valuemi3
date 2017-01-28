class AddProductIdToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :product_id, :integer
  end
end
