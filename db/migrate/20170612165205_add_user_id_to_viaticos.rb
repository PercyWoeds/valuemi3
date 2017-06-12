class AddUserIdToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :user_id, :integer
  end
end
