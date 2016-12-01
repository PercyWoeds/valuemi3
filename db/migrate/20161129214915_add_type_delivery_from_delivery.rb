class AddTypeDeliveryFromDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :type_delivery, :integer
  end
end
