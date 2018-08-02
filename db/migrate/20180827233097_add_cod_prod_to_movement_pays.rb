class AddCodProdToMovementPays < ActiveRecord::Migration
  def change
    add_column :movement_pays, :cod_prod, :string
  end
end
