class AddCodeToProductsCategories < ActiveRecord::Migration
  def change
    add_column :products_categories, :code, :string
  end
end
