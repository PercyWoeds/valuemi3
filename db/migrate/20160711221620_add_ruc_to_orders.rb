class AddRucToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ruc, :string
  end
end
