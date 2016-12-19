class AddCompanyIdToModelos < ActiveRecord::Migration
  def change
    add_column :modelos, :company_id, :integer
  end
end
