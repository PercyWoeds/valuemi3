class AddDetraccionImporteToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :detraccion_importe, :float
    add_column :facturas, :detraccion_percent, :float
    add_column :facturas, :detraccion_cuenta , :string 
    add_column :facturas, :detraccion_descrip, :string 
    
  end
end
