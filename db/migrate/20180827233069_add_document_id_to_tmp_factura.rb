class AddDocumentIdToTmpFactura < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :document_id, :integer
    add_column :tmp_facturas, :moneda_id, :integer
  end
end
