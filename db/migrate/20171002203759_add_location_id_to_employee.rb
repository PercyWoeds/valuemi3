class AddLocationIdToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :location_id, :integer
  end
end
