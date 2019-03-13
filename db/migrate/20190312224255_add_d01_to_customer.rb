class AddD01ToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :d01, :float
    add_column :customers, :d02, :float
    add_column :customers, :d03, :float
    add_column :customers, :d04, :float
    add_column :customers, :d05, :float
    add_column :customers, :d06, :float
    
  end
end
