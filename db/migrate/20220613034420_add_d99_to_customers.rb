class AddD99ToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :d99, :float
  end
end
