class ChangeIngresoToFloat < ActiveRecord::Migration
  def change
  	  	change_column :movement_details, :stock_inicial, :float
  	  	change_column :movement_details, :stock_final, :float
  	  	change_column :movement_details, :ingreso, :float
  	  	change_column :movement_details, :salida, :float
  	  	change_column :movement_details, :quantity, :float
  end
end
