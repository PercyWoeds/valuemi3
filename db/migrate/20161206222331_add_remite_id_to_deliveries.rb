class AddRemiteIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :remite_id, :integer
  end
end
