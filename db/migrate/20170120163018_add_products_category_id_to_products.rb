class AddProductsCategoryIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :products_category_id, :integer
  end
end
