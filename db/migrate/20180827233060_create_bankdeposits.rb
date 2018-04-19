class CreateBankdeposits < ActiveRecord::Migration
  def change
    create_table :bankdeposits do |t|
      t.string :fecha
      t.string :code
      t.integer :bank_account_id
      t.integer :document_id
      t.string :documento
      t.float :total

      t.timestamps null: false
    end
  end
end
