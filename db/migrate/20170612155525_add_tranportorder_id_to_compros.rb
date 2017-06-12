class AddTranportorderIdToCompros < ActiveRecord::Migration
  def change
    add_column :compros, :tranportorder_id, :integer
  end
end
