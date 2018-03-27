class AddVentaislaIdToVentaislaDetails < ActiveRecord::Migration
  def change
    add_column :ventaisla_details, :ventaisla_id, :integer
  end
end
