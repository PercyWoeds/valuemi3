class AddTotingresoToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :totingreso, :float
    add_column :payroll_details, :quinta, :float
    add_column :payroll_details, :faltas, :float
    
  end
end
