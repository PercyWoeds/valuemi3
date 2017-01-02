class AddTipoToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :tipo, :string
  end
end
