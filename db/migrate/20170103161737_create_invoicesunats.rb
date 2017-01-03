class CreateInvoicesunats < ActiveRecord::Migration
  def change
    create_table :invoicesunats do |t|
      t.string :cliente
      t.date :fecha
      t.string :td
      t.string :serie
      t.string :numero
      t.decimal :preciocigv
      t.decimal :preciosigv
      t.float :cantidad
      t.float :vventa
      t.float :igv
      t.float :importe
      t.string :ruc
      t.string :guia
      t.string :codplaca10
      t.string :formapago
      t.text :description
      t.text :comments
      t.string :descrip

      t.timestamps null: false
    end
  end
end
