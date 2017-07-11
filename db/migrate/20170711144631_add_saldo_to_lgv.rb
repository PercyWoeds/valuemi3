class AddSaldoToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :saldo, :float
  end
end
