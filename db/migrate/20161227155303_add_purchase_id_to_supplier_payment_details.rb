class AddPurchaseIdToSupplierPaymentDetails < ActiveRecord::Migration
  def change
    add_column :supplier_payment_details, :purchase_id, :integer
  end
end
