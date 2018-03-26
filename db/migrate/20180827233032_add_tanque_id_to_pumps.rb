class AddTanqueIdToPumps < ActiveRecord::Migration
  def change
    add_column :pumps, :tanque_id, :integer
  end
end
