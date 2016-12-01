class AddPrice2toProduct < ActiveRecord::Migration
  def change
  	    add_column :products, :price2, :float
  end
end
