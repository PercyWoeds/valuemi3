class AddTotalToFaltantes < ActiveRecord::Migration
  def change
    add_column :faltantes, :total, :float
  end
end
