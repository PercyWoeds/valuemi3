class AddTranportorderIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :tranportorder_id, :integer
  end
end
