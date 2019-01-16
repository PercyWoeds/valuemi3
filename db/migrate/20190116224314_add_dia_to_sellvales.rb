class AddDiaToSellvales < ActiveRecord::Migration
  def change
    add_column :sellvales, :dia, :integer
  end
end
