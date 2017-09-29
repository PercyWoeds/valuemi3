class RemoveYearMonthToTempfacturas < ActiveRecord::Migration
  def change
    remove_column :tempfacturas, :year_month, :float
  end
end
