class AddIslandIdToPump < ActiveRecord::Migration
  def change
    add_column :pumps, :island_id, :integer
  end
end
