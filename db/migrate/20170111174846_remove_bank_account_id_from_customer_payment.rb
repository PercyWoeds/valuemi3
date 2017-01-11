class RemoveBankAccountIdFromCustomerPayment < ActiveRecord::Migration
  def change
    remove_column :customer_payments, :BankAccountId, :integer
  end
end
