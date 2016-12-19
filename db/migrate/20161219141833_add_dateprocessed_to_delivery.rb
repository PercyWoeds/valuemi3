class AddDateprocessedToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :date_processed, :datetime
  end
end
