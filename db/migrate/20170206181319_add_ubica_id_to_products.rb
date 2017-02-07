class AddUbicaIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ubica_id, :integer
  end
end
