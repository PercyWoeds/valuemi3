class AddDateProcessedToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :date_processed, :datetime
  end
end
