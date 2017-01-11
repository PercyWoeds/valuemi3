class AddBankAcountIdToCustomerPayment < ActiveRecord::Migration
  def change
    add_column :customer_payments, :bank_acount_id, :integer
  end
end
