class AddYearMonthToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :year_mounth, :string
  end
end
