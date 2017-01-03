class CreateInvoiceitems < ActiveRecord::Migration
  def change
    create_table :invoiceitems do |t|
      t.integer :factura_id
      t.string :code
      t.string :cantidad
      t.string :um
      t.string :codigo
      t.string :descrip
      t.float :vunit
      t.float :punit
      t.float :vventa

      t.timestamps null: false
    end
  end
end
