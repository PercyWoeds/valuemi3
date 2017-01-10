class AddPagoToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :pago, :float
  end
end
