class AddFecha3ToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :fecha3, :datetime
  end
end
