class AddCompanyidToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :company_id, :integer
    
  end
end
