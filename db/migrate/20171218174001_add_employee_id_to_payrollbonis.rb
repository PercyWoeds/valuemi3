class AddEmployeeIdToPayrollbonis < ActiveRecord::Migration
  def change
    add_column :payrollbonis, :employee_id, :integer
  end
end
