class ChangeQuantityToFloat < ActiveRecord::Migration
  def change
  	change_column :output_details, :quantity, :float
  end
end
