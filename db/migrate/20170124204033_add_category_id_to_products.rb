class AddCategoryIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :Category_id, :integer
  end
end
