class AddCompanyIdToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :company_id, :integer
    add_column :parameters, :user_id, :integer
  end
end
