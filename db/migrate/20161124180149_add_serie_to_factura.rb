class AddSerieToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :serie, :string
  end
end
