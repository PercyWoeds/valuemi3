class ChangepriceMovementDetails < ActiveRecord::Migration
  def change
  	  change_column :movement_details, :price, :float
  end
end
