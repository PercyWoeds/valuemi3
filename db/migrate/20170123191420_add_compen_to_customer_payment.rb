class AddCompenToCustomerPayment < ActiveRecord::Migration
  def change
    add_column :customer_payments, :compen, :float
  end
end
