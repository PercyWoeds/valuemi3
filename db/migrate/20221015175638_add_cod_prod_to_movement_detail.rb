class AddCodProdToMovementDetail < ActiveRecord::Migration
  def change
    add_column :movement_details, :cod_prod, :string
  end
end
