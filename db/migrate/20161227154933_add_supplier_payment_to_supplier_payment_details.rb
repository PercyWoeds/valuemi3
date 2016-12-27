class AddSupplierPaymentToSupplierPaymentDetails < ActiveRecord::Migration
  def change
    add_column :supplier_payment_details, :supplierpayment_id, :integer
  end
end
