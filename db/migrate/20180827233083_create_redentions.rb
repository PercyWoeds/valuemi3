class CreateRedentions < ActiveRecord::Migration
  def change
    create_table :redentions do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :customer_id
      t.integer :customer_id
      t.string :description
      t.text :comments
      t.string :code
      t.float :subtotal
      t.float :tax
      t.float :total
      t.string :processed
      t.string :return
      t.datetime :date_processed
      t.integer :user_id
      t.datetime :fecha
      t.string :serie
      t.string :numero
      t.integer :payment_id
      t.integer :factura_id
      t.string :tipo
      t.string :pago
      t.float :charge
      t.float :balance
      t.integer :moneda_id
      t.string :observ
      t.datetime :fecha2
      t.string :year_mounth
      t.float :detraccion
      t.string :numero2
      t.integer :document_id
      t.float :descuento
      t.string :tipoventa
      t.integer :tipoventa_id
      t.string :ruc
      t.integer :tarjeta_id

      t.timestamps null: false
    end
  end
end
