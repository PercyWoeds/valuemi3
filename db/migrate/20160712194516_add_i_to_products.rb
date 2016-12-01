class AddIToProducts < ActiveRecord::Migration
  def change
    add_column :products, :i, :integer
  end
end
