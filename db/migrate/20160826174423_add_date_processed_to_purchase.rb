class AddDateProcessedToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :date_processed, :datetime
  end
end
