class AddIdSurtidorToPumps < ActiveRecord::Migration
  def change
    add_column :pumps, :id_surtidor, :integer
  end
end
