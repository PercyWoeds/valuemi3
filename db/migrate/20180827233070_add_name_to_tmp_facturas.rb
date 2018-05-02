class AddNameToTmpFacturas < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :name, :string
  end
end
