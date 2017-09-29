class AddTypePayrollIdToPayrolls < ActiveRecord::Migration
  def change
    add_column :payrolls, :type_payroll_id, :integer
  end
end
