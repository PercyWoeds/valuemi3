class AddQtyTransitToProduct < ActiveRecord::Migration
  def change
    add_column :products, :quantity_transit, :integer
  end
end
