class AddCuentaToBankAcount < ActiveRecord::Migration
  def change
    add_column :bank_acounts, :cuenta, :string
  end
end
