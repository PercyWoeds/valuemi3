class RemoveCustomerPaymentDetailIdFromCustomerPaymentDetails < ActiveRecord::Migration
  def change
    remove_column :customer_payment_details, :customer_payment_detail_id, :integer
  end
end
