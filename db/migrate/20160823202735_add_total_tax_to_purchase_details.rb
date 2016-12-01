class AddTotalTaxToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :totaltax, :float
  end
end
