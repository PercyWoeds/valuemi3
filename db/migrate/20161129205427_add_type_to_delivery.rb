class AddTypeToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :type, :integer
  end
end
