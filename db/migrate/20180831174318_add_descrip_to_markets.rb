class AddDescripToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :descrip, :string
  end
end
