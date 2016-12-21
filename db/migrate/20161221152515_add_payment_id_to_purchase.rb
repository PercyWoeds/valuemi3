class AddPaymentIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :payment_id, :integer
  end
end
