class AddPrice3ToFacturaDetail < ActiveRecord::Migration
  def change
    add_column :factura_details, :price3, :float ,  precision: 15, :scale => 2
  end
end
