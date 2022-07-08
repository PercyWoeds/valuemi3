class AddName2ToProduct < ActiveRecord::Migration
  def change
    add_column :products, :name2, :string
  end
end
