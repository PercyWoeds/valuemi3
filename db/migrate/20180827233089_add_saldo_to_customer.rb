class AddSaldoToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :saldo, :integer
  end
end
