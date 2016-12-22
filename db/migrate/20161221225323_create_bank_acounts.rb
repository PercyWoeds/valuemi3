class CreateBankAcounts < ActiveRecord::Migration
  def change
    create_table :bank_acounts do |t|
      t.string :number
      t.integer :moneda_id
      t.integer :bank_id

      t.timestamps null: false
    end
  end
end
