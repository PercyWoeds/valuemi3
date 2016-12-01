class AddTotalTax2ToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :totaltax2, :float
  end
end
