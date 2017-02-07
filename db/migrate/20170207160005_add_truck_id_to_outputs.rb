class AddTruckIdToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :truck_id, :integer
  end
end
