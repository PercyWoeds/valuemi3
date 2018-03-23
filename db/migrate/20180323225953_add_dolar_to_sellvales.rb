class AddDolarToSellvales < ActiveRecord::Migration
  def change
    add_column :sellvales, :dolar, :float
  end
end
