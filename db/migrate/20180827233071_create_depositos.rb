class CreateDepositos < ActiveRecord::Migration
  def change
    create_table :depositos do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :bank_account_id
      t.integer :document_id
      t.string :documento
      t.integer :customer_id
      t.string :tm
      t.float :total
      t.datetime :fecha1
      t.datetime :fecha2
      t.string :nrooperacion
      t.text :descrip
      t.text :comments
      t.integer :user_id
      t.string :processed
      t.datetime :date_processed
      t.string :code
      t.integer :bank_acount_id
      t.integer :concept_id
      t.float :compen

      t.timestamps null: false
    end
  end
end
