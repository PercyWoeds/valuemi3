class AddIslandIdToIslands < ActiveRecord::Migration
  def change
    add_column :islands, :island_id, :integer
  end
end
