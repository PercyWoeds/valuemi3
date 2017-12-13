class CreateBankdetails < ActiveRecord::Migration
  def change
    create_table :bankdetails do |t|
      t.integer :bank_acount_id
      t.datetime :fecha
      t.float :saldo_inicial
      t.float :total_abono
      t.float :total_cargo
      t.float :saldo_final
      t.float :company_id 

      t.timestamps null: false
    end
  end
end
