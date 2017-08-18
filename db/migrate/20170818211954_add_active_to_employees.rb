class AddActiveToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :active, :string
  end
end
