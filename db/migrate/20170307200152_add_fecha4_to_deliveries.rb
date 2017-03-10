class AddFecha4ToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :fecha4, :datetime
  end
end
