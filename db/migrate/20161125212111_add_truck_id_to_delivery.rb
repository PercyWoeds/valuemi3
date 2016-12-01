class AddTruckIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :truck_id, :integer
  end
end
