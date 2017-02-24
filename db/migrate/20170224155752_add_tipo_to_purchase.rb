class AddTipoToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :tipo, :string
  end
end
