class AddTmIdToPayrollbonis < ActiveRecord::Migration
  def change
    add_column :payrollbonis, :tm_id, :integer
  end
end
