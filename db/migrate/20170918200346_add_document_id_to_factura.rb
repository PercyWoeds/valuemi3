class AddDocumentIdToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :document_id, :integer
  end
end
