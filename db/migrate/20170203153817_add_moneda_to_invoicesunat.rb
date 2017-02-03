class AddMonedaToInvoicesunat < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :moneda, :integer
  end
end
