class AddDiaToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :dia, :datetime
  end
end
