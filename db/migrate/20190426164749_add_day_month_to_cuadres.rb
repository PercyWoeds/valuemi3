class AddDayMonthToCuadres < ActiveRecord::Migration
  def change
    add_column :cuadres, :day_month, :integer
  end
end
