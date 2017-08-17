class AddEmployeeIdToViaticoDetail < ActiveRecord::Migration
  def change
    add_column :viatico_details, :employee_id, :integer
  end
end
