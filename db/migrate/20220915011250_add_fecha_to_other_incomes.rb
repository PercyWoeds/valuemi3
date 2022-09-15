class AddFechaToOtherIncomes < ActiveRecord::Migration
  def change
    add_column :other_incomes, :fecha, :datetime
  end
end
