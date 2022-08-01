class AddAnexo8IdToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :anexo8_id, :integer
  end
end
