class AddDocumento2ToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :documento2, :string
  end
end
