class AddSupplierIdToGastos < ActiveRecord::Migration
  def change
    add_column :gastos, :supplier_id, :integer
  end
end
