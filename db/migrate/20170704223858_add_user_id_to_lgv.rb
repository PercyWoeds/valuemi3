class AddUserIdToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :user_id, :integer
  end
end
