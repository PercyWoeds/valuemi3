class AddComisionFlujoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :comision_flujo, :integer
  end
end
