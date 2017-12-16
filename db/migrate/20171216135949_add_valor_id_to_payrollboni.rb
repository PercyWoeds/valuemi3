class AddValorIdToPayrollboni < ActiveRecord::Migration
  def change
    add_column :payrollbonis, :valor_id, :integer
    add_column :payrollbonis, :payroll_id, :integer
    
  end
end
