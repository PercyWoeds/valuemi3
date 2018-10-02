class AddRefenceFactToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :reference_fact, :integer
  end
end
