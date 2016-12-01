class AddFacturaIDtoInvoiceService < ActiveRecord::Migration
  def change
  	add_column :facturas, :factura_id, :integer
  end
end
