class AddPriceToMovementPay < ActiveRecord::Migration
  def change
    add_column :movement_pays, :price, :float
    add_column :movement_pays, :price_discount, :float
    add_column :movement_pays, :import, :float
    add_column :movement_pays, :import_lista, :float
    
  end
end
