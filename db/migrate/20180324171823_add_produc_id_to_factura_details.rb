class AddProducIdToFacturaDetails < ActiveRecord::Migration
  def change
    add_column :factura_details, :product_id, :integer
  end
end
