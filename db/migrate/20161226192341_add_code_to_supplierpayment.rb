class AddCodeToSupplierpayment < ActiveRecord::Migration
  def change
    add_column :supplier_payments, :code, :string
  end
end
