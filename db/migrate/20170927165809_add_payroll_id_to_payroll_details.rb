class AddPayrollIdToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :payroll_id, :integer
  end
end
