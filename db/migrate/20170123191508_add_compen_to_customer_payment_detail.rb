class AddCompenToCustomerPaymentDetail < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :compen, :float
  end
end
