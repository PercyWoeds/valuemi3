class AddAddressIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :address_id, :integer
  end
end
