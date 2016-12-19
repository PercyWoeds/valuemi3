class AddCompanyidToMoneda < ActiveRecord::Migration
  def change
    add_column :monedas, :company_id, :integer
  end
end
