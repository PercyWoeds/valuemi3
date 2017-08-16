class AddIdNumberToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :IdNumber, :string
  end
end
