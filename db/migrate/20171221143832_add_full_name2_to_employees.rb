class AddFullName2ToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :full_name2, :string
  end
end
