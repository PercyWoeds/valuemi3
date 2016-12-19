class AddCompanyIdToMarcas < ActiveRecord::Migration
  def change
    add_column :marcas, :company_id, :integer
  end
end
