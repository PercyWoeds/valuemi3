class AddSupplierIdToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :supplier_id, :integer
  end
end
