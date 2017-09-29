class AddAfpIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :afp_id, :integer
  end
end
