class AddDiasToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :dias, :float
  end
end
