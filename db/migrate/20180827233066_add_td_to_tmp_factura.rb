class AddTdToTmpFactura < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :td, :string
  end
end
