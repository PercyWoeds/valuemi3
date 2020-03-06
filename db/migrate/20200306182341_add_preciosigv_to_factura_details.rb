class AddPreciosigvToFacturaDetails < ActiveRecord::Migration
  def change
    add_column :factura_details, :preciosigv, :float
  end
end
