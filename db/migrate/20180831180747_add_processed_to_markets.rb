class AddProcessedToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :processed, :string
  end
end
