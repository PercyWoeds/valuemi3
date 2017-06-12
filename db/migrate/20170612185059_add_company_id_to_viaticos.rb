class AddCompanyIdToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :company_id, :integer
  end
end
