class AddAddres2idToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :address2_id, :integer
  end
end
