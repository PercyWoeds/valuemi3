class AddDiscountToFacturaDetails < ActiveRecord::Migration
  def change
    add_column :factura_details, :discount, :float
  end
end
