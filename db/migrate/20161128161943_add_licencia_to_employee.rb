class AddLicenciaToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :licencia, :string
  end
end
