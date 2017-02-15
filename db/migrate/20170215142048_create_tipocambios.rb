class CreateTipocambios < ActiveRecord::Migration
  def change
    create_table :tipocambios do |t|
      t.datetime :dia
      t.float :compra
      t.float :venta

      t.timestamps null: false
    end
  end
end
