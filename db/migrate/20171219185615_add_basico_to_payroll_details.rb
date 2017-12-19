class AddBasicoToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :basico, :float
  end
end
