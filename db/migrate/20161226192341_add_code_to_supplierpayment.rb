class AddCodeToSupplierpayment < ActiveRecord::Migration
  def change
    add_column :Supplier_Payments, :code, :string
  end
end
