class AddAsignacionToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :asignacion, :integer
  end
end
