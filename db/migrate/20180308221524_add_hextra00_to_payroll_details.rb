class AddHextra00ToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :hextra00, :float
  end
end
