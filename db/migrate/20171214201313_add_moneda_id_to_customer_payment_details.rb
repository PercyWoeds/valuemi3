class AddMonedaIdToCustomerPaymentDetails < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :moneda_id, :integer
  end
end
