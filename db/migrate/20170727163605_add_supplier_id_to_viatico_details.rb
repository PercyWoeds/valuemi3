class AddSupplierIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :supplier_id, :integer
  end
end
