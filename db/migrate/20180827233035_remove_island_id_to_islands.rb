class RemoveIslandIdToIslands < ActiveRecord::Migration
  def change
    remove_column :islands, :island_id, :integer
  end
end
