class AddOnpToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :onp, :string
  end
end
