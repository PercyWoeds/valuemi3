class AddPercepcionToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :percepcion, :float
  end
end
