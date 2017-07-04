class AddSupplierIdToLgvDetails < ActiveRecord::Migration
  def change
    add_column :lgv_details, :supplier_id, :integer
  end
end
