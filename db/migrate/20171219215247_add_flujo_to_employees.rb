class AddFlujoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :flujo, :integer
  end
end
