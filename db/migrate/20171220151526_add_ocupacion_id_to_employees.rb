class AddOcupacionIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :ocupacion_id, :integer
  end
end
