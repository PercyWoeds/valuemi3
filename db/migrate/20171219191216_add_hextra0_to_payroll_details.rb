class AddHextra0ToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :hextra0, :float
  end
end
