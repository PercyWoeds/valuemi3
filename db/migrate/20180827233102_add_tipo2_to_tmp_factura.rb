class AddTipo2ToTmpFactura < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :tipo2, :string
  end
end
