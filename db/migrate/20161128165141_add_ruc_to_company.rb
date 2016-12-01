class AddRucToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :ruc, :string
  end
end
