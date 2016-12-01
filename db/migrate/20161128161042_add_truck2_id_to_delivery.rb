class AddTruck2IdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :truck2_id, :integer
  end
end
