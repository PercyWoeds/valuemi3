class AddTasa2ToFiveparameters < ActiveRecord::Migration
  def change
    add_column :fiveparameters, :tasa2, :float
    add_column :fiveparameters, :tasa3, :float
    add_column :fiveparameters, :tasa4, :float
    add_column :fiveparameters, :tasa5, :float
    add_column :fiveparameters, :tasa6, :float
    add_column :fiveparameters, :tasa7, :float
    add_column :fiveparameters, :tasa8, :float
  end
end
