class AddBalanceToCustomerPaymentDetails < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :balance, :float
    
  end
end
