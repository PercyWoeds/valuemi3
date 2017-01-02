class RemovePaymentFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :payment, :float 
  end
end
