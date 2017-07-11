class AddLgvIdToLgvDetails < ActiveRecord::Migration
  def change
    add_column :lgv_details, :lgv_id, :integer
  end
end
