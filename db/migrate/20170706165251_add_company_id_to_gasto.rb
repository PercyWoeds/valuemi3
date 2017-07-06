class AddCompanyIdToGasto < ActiveRecord::Migration
  def change
    add_column :gastos, :company_id, :integer
  end
end
