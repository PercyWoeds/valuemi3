class AddVacacionesToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :vacaciones, :float
    add_column :payroll_details, :desmedico, :float
    add_column :payroll_details, :subsidio0, :float
  end
end
