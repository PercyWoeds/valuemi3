class CreateSupplierPaymentDetails < ActiveRecord::Migration
  def change
    create_table :supplier_payment_details do |t|
      t.integer :document_id
      t.string :documento
      t.integer :supplier_id
      t.string :tm
      t.float :total
      t.text :descrip

      t.timestamps null: false
    end
  end
end
