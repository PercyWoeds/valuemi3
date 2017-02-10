class ChangeQuantityService < ActiveRecord::Migration
  def change
  	change_column :services, :quantity, :float
  	
  end
end
