class AddLoanIdToLoanDetails < ActiveRecord::Migration
  def change
    add_column :loan_details, :loan_id, :integer
  end
end
