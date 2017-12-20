class AddAporteToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :aporte, :float
    add_column :payroll_details, :seguro, :float
    add_column :payroll_details, :comision, :float
  end
end
