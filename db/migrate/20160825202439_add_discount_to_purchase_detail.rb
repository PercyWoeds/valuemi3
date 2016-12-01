class AddDiscountToPurchaseDetail < ActiveRecord::Migration
  def change
    add_column :purchase_details, :discount, :float
  end
end
