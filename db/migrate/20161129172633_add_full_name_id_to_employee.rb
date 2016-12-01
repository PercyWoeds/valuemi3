class AddFullNameIdToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :full_name, :string
  end
end
