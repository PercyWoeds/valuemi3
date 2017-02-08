class AddUbicacionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ubicacion, :string
  end
end
