class AddCuentadetToProduct < ActiveRecord::Migration
  def change
    add_column :products, :cuentadet, :string
  end
end
