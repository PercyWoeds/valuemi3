class AddCategoryToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :category, :string
  end
end
