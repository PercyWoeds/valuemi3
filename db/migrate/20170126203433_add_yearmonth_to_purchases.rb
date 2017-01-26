class AddYearmonthToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :yearmonth, :string
  end
end
