class AddNumero2ToTmpFacturas < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :numero2, :string
  end
end
