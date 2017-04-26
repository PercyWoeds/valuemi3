class AddDolarToServiceorders < ActiveRecord::Migration
  def change
    add_column :serviceorders, :dolar, :float
  end
end
