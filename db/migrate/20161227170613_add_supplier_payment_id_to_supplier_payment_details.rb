class AddSupplierPaymentIdToSupplierPaymentDetails < ActiveRecord::Migration
  def change
    add_column :supplier_payment_details, :supplier_payment_id, :integer
  end
end
