class AddRetencionImporteToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :retencion_importe, :float
  end
end
