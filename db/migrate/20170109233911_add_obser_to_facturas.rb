class AddObserToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :observ, :text
  end
end
