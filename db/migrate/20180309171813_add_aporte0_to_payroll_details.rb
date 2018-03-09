class AddAporte0ToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :aporte0, :float
    add_column :payroll_details, :seguro0, :float
    add_column :payroll_details, :comision0, :float
  end
end
