class AddCcostoIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :ccosto_id, :integer
  end
end
