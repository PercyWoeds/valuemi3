class AddYearMonthToTempfacturas < ActiveRecord::Migration
  def change
    add_column :tempfacturas, :year_month, :string
  end
end
