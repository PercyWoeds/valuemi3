class AddServicioToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :servicio, :string
  end
end
