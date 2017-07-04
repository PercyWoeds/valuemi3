class AddCompanyIdToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :company_id, :integer
  end
end
