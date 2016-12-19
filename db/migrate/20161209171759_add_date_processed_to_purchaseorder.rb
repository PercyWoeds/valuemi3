class AddDateProcessedToPurchaseorder < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :date_processed, :datetime
  end
end
