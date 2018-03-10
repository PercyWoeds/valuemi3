class AddCussppToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :cusspp, :string
  end
end
