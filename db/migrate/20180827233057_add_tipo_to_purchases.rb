class AddTipoToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :tiponota, :string
  end
end
