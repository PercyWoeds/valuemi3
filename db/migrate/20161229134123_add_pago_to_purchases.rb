class AddPagoToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :pago, :float
  end
end
