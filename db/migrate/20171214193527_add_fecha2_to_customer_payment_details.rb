class AddFecha2ToCustomerPaymentDetails < ActiveRecord::Migration
  def change
    add_column :customer_payment_details,  :fecha2,:datetime
    add_column :customer_payment_details,  :month_year ,:string 
  end
end
