class AddFactoryToCustomerPaymentDetail < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :factory, :float
  end
end
