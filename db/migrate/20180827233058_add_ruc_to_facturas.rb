class AddRucToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :ruc, :string
  end
end
