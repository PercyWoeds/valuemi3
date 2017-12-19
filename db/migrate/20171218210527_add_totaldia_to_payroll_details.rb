class AddTotaldiaToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :totaldia, :float
    add_column :payroll_details, :falta, :float
    add_column :payroll_details, :vaca, :float
    add_column :payroll_details, :desmed, :float
    add_column :payroll_details, :subsidio, :float
    add_column :payroll_details, :hextra, :float
    add_column :payroll_details, :reintegro, :float
    add_column :payroll_details, :otros, :float
    
  end
end
