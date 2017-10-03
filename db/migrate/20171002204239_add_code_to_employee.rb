class AddCodeToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :code, :string
  end
end
