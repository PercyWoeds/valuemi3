class AddItoDelivery < ActiveRecord::Migration
  def change
  	    add_column :deliveries, :i, :float
  end
end
