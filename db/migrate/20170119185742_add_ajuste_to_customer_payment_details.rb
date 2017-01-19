class AddAjusteToCustomerPaymentDetails < ActiveRecord::Migration
  def change
    add_column :customer_payment_details, :ajuste, :float
  end
end
