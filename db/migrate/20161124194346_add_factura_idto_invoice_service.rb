class AddFacturaIdtoInvoiceService < ActiveRecord::Migration
  def change
  	add_column :Invoice_Services, :factura_id, :integer
  end
end
