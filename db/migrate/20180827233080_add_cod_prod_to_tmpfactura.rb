class AddCodProdToTmpfactura < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :cod_prod, :string
  end
end
