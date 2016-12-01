class AddCompanyIdToUnidad < ActiveRecord::Migration
  def change
    add_column :unidads, :company_id, :integer
  end
end
