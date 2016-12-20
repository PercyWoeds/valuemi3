class AddFecha2ToPurchaseorders < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :fecha2, :datetime
  end
end
