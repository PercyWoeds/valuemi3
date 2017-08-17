class AddIdnumberToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :idnumber, :string
  end
end
