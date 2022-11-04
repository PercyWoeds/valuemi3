class AddTipoCambioToCustomerPayments < ActiveRecord::Migration
  def change
    add_column :customer_payments, :tipo_cambio, :float
    add_column :customer_payments, :importe_cambio, :float
    
  end
end
