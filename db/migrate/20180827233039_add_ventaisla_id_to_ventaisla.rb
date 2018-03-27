class AddVentaislaIdToVentaisla < ActiveRecord::Migration
  def change
    add_column :ventaislas, :ventaisla_id, :integer
  end
end
