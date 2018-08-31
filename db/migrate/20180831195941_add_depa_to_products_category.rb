class AddDepaToProductsCategory < ActiveRecord::Migration
  def change
    add_column :products_categories, :cod_dep, :string
  end
end
