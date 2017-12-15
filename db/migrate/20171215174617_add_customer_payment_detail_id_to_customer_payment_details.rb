class AddCustomerPaymentDetailIdToCustomerPaymentDetails < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :customer_payment_detail_id, :integer
  end
end
