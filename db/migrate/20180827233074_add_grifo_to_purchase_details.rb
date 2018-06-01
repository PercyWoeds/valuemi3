class AddGrifoToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :grifo, :float
    add_column :purchase_details, :mayorista, :float
  end
end
