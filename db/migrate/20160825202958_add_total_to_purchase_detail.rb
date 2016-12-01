class AddTotalToPurchaseDetail < ActiveRecord::Migration
  def change
    add_column :purchase_details, :total, :float
  end
end
