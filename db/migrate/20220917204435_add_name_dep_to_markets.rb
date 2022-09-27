class AddNameDepToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :name_dep, :string
  end
end
