class AddModeloIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :modelo_id, :integer
  end
end
