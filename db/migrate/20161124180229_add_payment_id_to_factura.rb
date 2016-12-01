class AddPaymentIdToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :payment_id, :string
  end
end
