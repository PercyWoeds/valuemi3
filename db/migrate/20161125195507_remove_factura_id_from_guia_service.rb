class RemoveFacturaIdFromGuiaService < ActiveRecord::Migration
  def change
    remove_column :guia_services, :factura_id, :integer
  end
end
