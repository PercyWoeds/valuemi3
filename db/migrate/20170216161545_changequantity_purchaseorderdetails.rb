class ChangequantityPurchaseorderdetails < ActiveRecord::Migration
  def change
  	  	change_column :purchaseorder_details, :quantity, :float
  end
end
