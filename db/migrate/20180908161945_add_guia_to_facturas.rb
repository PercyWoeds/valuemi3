class AddGuiaToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :guia, :string
  end
end
