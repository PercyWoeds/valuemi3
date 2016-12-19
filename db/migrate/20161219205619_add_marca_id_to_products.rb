class AddMarcaIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :marca_id, :integer
  end
end
