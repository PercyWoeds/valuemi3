class AddImporte2ToSellvales < ActiveRecord::Migration
  def change
    add_column :sellvales, :importe2, :float
  end
end
