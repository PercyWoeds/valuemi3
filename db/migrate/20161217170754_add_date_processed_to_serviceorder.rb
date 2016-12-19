class AddDateProcessedToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :date_processed, :datetime
  end
end
