class AddTotalToLoanDetails < ActiveRecord::Migration
  def change
    add_column :loan_details, :total, :float
  end
end
