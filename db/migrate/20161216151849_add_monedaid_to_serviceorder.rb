class AddMonedaidToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :moneda_id, :integer
  end
end
