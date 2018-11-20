class AddIslandIdToVentaIslas < ActiveRecord::Migration
  def change
    add_column :ventaislas, :island_id, :integer
  end
end
