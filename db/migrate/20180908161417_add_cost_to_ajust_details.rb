class AddCostToAjustDetails < ActiveRecord::Migration
  def change
    add_column :ajust_details, :cost, :float
  end
end
