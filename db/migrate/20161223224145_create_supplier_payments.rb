class CreateSupplierPayments < ActiveRecord::Migration
  def change
    create_table :supplier_payments do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :bank_acount_id
      t.integer :document_id
      t.string :documento
      t.integer :supplier_id
      t.string :tm
      t.float :total
      t.datetime :fecha1
      t.datetime :fecha2
      t.string :nrooperacion
      t.string :operacion
      t.text :descrip
      t.text :comments
      t.integer :user_id
      t.string :processed
      t.datetime :date_processed

      t.timestamps null: false
    end
  end
end
