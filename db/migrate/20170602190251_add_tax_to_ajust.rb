class AddTaxToAjust < ActiveRecord::Migration
  def change
    add_column :ajusts, :tax, :float
  end
end
