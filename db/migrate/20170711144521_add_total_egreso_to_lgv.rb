class AddTotalEgresoToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :total_egreso, :float
  end
end
