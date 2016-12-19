class AddCompanyidToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :company_id, :integer
  end
end
