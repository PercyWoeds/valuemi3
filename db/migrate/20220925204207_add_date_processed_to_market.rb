class AddDateProcessedToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :date_processed, :datetime 
  end
end
