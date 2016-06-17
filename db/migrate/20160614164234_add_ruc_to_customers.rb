class AddRucToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :ruc, :string
  end
end
