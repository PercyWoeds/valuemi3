class AddPuntoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :punto, :integer
  end
end
