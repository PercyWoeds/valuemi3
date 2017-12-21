class AddPlanillaToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :planilla, :string
  end
end
