class RemoveSupplierpaymentidFromSupplierPaymentDetails < ActiveRecord::Migration
  def change
    remove_column :supplier_payment_details, :supplierpayment_id, :integer
  end
end
