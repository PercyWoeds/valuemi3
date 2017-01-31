class AddCuentaToService < ActiveRecord::Migration
  def change
    add_column :services, :cuenta, :string
  end
end
