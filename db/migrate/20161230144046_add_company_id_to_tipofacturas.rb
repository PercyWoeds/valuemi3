class AddCompanyIdToTipofacturas < ActiveRecord::Migration
  def change
    add_column :tipofacturas, :company_id, :integer
  end
end
