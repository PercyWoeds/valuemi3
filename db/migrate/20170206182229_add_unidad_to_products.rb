class AddUnidadToProducts < ActiveRecord::Migration
  def change
    add_column :products, :unidad, :string
  end
end
