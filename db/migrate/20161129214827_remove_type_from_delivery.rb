class RemoveTypeFromDelivery < ActiveRecord::Migration
  def change
    remove_column :deliveries, :type, :integer
  end
end
