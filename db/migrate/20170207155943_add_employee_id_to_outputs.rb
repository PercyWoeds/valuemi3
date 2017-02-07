class AddEmployeeIdToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :employee_id, :integer
  end
end
