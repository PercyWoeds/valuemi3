class CreateCustomerPaymentDetails < ActiveRecord::Migration
  def change
    create_table :customer_payment_details do |t|
      t.integer :document_id
      t.string :documento
      t.integer :customer_id
      t.string :tm
      t.float :total
      t.text :descrip
      t.integer :factura_id
      t.integer :customer_payment_id

      t.timestamps null: false
    end
  end
end
