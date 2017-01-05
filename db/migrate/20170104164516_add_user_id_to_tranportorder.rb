class AddUserIdToTranportorder < ActiveRecord::Migration
  def change
    add_column :tranportorders, :user_id, :integer
  end
end
