class AddCodEmpToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :cod_emp, :string
  end
end
