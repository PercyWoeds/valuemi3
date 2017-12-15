class AddCustomerPaymentDetailIdToTempcps < ActiveRecord::Migration
  def change
    add_column :tempcps, :customer_payment_detail_id, :integer
  end
end
